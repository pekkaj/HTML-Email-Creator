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
    def initialize(text, default_data = HtmlEmailCreator.settings.extension_data)
      @template = Liquid::Template.parse(text)
      @default_data = default_data
    end
        
    def to_html(data = {}, *filters)
      @template.render(@default_data.merge(data), :filters => [BuiltInFilters] + filters)
    end
  end
end