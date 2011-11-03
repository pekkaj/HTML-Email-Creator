module HtmlEmailCreator
  module Formatters
    class PlainTextEmail < Formatter
      def self.extension
        "txt"
      end

      def self.id
        :plain_text_email
      end
      
      def initialize(html, settings)
        super
        @processor = HtmlEmailCreator::Processor.new(html, settings)
      end
  
      def format
        @output ||= @processor.to_plain_text
      end
    end
  end
end