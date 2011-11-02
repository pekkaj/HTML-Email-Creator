require "liquid"

module HtmlEmailCreator  
  class Formatter
    @@CONFIG = {
      :md => HtmlEmailCreator::Formatters::Markdown
    }
    
    def initialize(text)
      @text = text
    end
        
    def format(format)
      formatter = @@CONFIG[format.to_sym]
      if formatter
        formatter.send(:new, @text).send(:to_html)
      else
        @text
      end
    end
    
    def format_by_filename(filename)
      format(File.extname(filename).split(".").last)
    end
  end
end