module HtmlEmailCreator
  
  # Mail creation consists of many steps. This is a place where you coordinate additional steps.
  # In the future you may even register callbacks to your plugins if that feture is needed.
  class Callbacks
    
    def initialize(settings = HtmlEmailCreator.settings)
      @settings = settings
    end
    
    def html_created(html)
      HtmlEmailCreator::Extensions.new.process_html(html, *@settings.built_in_extensions)
    end
    
  end
end