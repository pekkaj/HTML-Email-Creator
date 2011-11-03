module HtmlEmailCreator
  module Formatters
    class UnknownFormatter < Formatter
      def self.extension
        "txt"
      end

      def self.id
        :unknown
      end
      
      def initialize(text, settings = HtmlEmailCreator.settings)
        super
      end
    end
  end
end