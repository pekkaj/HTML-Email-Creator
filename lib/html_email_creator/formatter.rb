require "liquid"

module HtmlEmailCreator
  class Formatter
    @@DEFAULT = HtmlEmailCreator::Formatters::UnknownFormatter
    @@CONFIG = {}

    [
      HtmlEmailCreator::Formatters::Markdown,
      HtmlEmailCreator::Formatters::PlainTextEmail,
      HtmlEmailCreator::Formatters::HtmlEmail
    ].each do |klass|
      @@CONFIG[klass.id] = klass
    end
    
    def initialize(text, settings = HtmlEmailCreator.settings)
      @text = text
      @settings = settings
    end
    
    def find(format)
      klass = @@CONFIG[format.to_sym] || @@DEFAULT
      klass.send(:new, @text, @settings)
    end
        
    def find_by_filename(filename)
      find(File.extname(filename).split(".").last)
    end
  end
end