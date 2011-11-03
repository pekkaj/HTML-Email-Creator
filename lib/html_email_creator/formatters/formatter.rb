module HtmlEmailCreator
  module Formatters
    class Formatter      
      def self.id
        raise "id needs to be defined"
      end

      def self.extension
        raise "extension needs to be defined"
      end
      
      def initialize(text, settings)
        @text = text
        @settings = settings
      end
      
      # override to implement a correct formatter
      def format
        @text
      end
      
      def id
        self.class.id
      end
      
      def extension
        self.class.extension
      end
    end
  end
end