require 'kramdown'

module HtmlEmailCreator
  module Formatters
    class Markdown < Formatter
      def self.extension
        "md"
      end
      
      def self.id
        :md
      end

      def initialize(text, settings)
        super
        @document = Kramdown::Document.new(text)
      end
  
      def format
        @output ||= @document.to_html.strip
      end
    end
  end
end