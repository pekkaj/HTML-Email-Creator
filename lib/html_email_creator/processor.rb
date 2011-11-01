require 'nokogiri'
require 'inline-style'

module HtmlEmailCreator
  class Processor
    def initialize(email_string, settings = HtmlEmailCreator.settings)
      @email = email_string
      @settings = settings
    end
    
    def to_html
      return @processed_html_email if @processed_html_email
      
      doc = Nokogiri::HTML(@email)
      headers = ["h1", "h2", "h3", "h4", "h5"]

      # wrap headers with div

      headers.each do |hx|
        nodes = doc.css hx
        nodes.wrap("<div class='#{hx}'></div>")
      end

      # replace headers with divs

      headers.each do |hx|
        doc.css(hx).each { |h| h.name = "div" }
      end

      # replace paragraphs with divs

      #doc.css("p").each { |p| p.name = "div" }

      # store file

      html_email = doc.to_html
      
      inlined_html_email = InlineStyle.process(html_email)
      
      # Then remove escaping of Aweber templates
      @processed_html_email = if @settings.extensions.include?("aweber")
        inlined_html_email.gsub(/%7B/, '{').gsub(/%7D/, '}').gsub(/!global%20/, '!global ')
      else
        inlined_html_email
      end
    end
    
    def to_plain_text
      return @processed_plain_text_email if @processed_plain_text_email
      
      doc = Nokogiri::HTML(to_html)
      doc.css('style').each { |node| node.remove }
      doc.css('title').each { |node| node.remove }
      doc.css('script').each { |node| node.remove }
      doc.css('link').each { |node| node.remove }
      doc.css('a').each do |node|
        img = node.at_css('img')
        node.content = if img
          "#{img['alt']} (#{node['href']})"
        else
          "#{node.content} (#{node['href']})"
        end
      end
      doc.css('img').each do |node|
        node.content = "#{node['alt']} (#{node['src']})"
      end
      doc.css('strong').each do |node| 
        node.content = "*#{node.content}*"
      end
      doc.css('li').each { |node| node.content = "- #{node.content.strip}" }

      # format all content that must have an empty line on top of them

      doc.css('div.h1 div').each do |node| 
        node.content = "\n#{'=' * 77}\n#{node.content}"
      end
      doc.css('div.h2 div').each do |node| 
        node.content = "\n#{'-' * 77}\n#{node.content}"
      end
      doc.css('div.h3 div').each do |node| 
        node.content = "\n#{'- ' * 39}\n#{node.content}"
      end
      doc.css('div.h4 div').each do |node| 
        node.content = "\n#{node.content}"
      end
      doc.css('p').each do |node| 
        node.content = "\n#{node.content}"
      end 

      doc.css('table.inline').each do |table|
        content = []
        table.css('tr').each do |row|
          # each_index method is missing
          i = 0
          row.css('td').each do |column|
            empty_column = column.content.strip.gsub(/^\p{Space}+|\p{Space}+$/, "").empty?
            if content[i]
              content[i] = content[i] + "\n* #{column.content}" unless empty_column
            else
              content[i] = "\n#{column.content}" unless empty_column
            end
            i = i + 1
          end
        end

        table.content = "#{content.join("\n")}\n"
      end

      # remove unnecessary whitespaces and empty lines
      previous = ""
      @processed_plain_text_email = doc.css('body').text.split("\n").map do |line|
        # Nokogiri uses UTF-8 whitespace character for &nbsp and strip doesn't support those
        res = line.gsub(/^\p{Space}+|\p{Space}+$/, "")
        new_previous = res
        res = nil if res.empty? && previous.empty?
        previous = new_previous
        res
      end.compact.join("\n")
    end
  end
end