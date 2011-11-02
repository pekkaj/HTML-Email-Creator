require "liquid"

module HtmlEmailCreator
  class Layout
    def initialize(text, default_data = HtmlEmailCreator.settings.extension_data)
      @template = Liquid::Template.parse(text)
      @default_data = default_data
    end
        
    def to_html(data = {}, *filters)
      @template.render(@default_data.merge(data), :filters => [HtmlEmailCreator::Filters] + filters)
    end
  end
end