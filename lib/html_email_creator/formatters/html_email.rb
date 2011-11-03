require 'kramdown'

module HtmlEmailCreator
  module Formatters
    class HtmlEmail < Formatter
      def self.extension
        "html"
      end
      
      def self.id
        :html_email
      end  
      
      def initialize(html, settings)
        super
        @processor = HtmlEmailCreator::Processor.new(html, settings)
      end
  
      def format
        @output ||= @processor.to_html
      end
    end
  end
end