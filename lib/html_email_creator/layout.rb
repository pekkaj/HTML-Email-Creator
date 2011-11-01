require "liquid"

module HtmlEmailCreator
  module BuiltInFilters
    def photo(input, alt)
      url = "#{HtmlEmailCreator.settings.cdn_url}/#{input}"
      "<img src=\"#{url}\" alt=\"#{alt}\" border=\"0\">"
    end

    def include(input)
      "include called"
    end
  end

  class Layout    
    def initialize(text, extensions = HtmlEmailCreator.settings.extensions)
      @template = Liquid::Template.parse(text)
      @default_data = read_default_data(extensions)
    end
        
    def to_html(data = {}, *filters)
      @template.render(@default_data.merge(data), :filters => [BuiltInFilters] + filters)
    end
    
    private
    
    def read_default_data(extensions)
      data = {}
      extensions.each do |extension|
        found_data = @@EXTENSIONS[extension]
        data.merge!(found_data) if found_data
      end
      data
    end
  end
end