module HtmlEmailCreator
  class Renderer
    def initialize(text, settings = HtmlEmailCreator.settings)
      @text = text
      @settings = settings
    end
        
    def to_html(data = {}, *filters)
      HtmlEmailCreator::Markdown.new(HtmlEmailCreator::Layout.new(@text, @settings.extensions).to_html(data, filters)).to_html
    end
  end    
end