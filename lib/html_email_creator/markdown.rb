require 'kramdown'

module HtmlEmailCreator
  class Markdown    
    def initialize(text)
      @document = Kramdown::Document.new(text)
    end
    
    def to_html
      @html ||= @document.to_html
    end
  end
end