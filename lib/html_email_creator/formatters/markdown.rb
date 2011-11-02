require 'kramdown'

module HtmlEmailCreator
  module Formatters
    class Markdown    
      def initialize(text)
        @document = Kramdown::Document.new(text)
      end
  
      def to_html
        @html ||= @document.to_html.strip
      end
    end
  end
end