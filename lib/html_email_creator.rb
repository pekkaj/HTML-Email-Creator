def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

require_all 'html_email_creator/tags'

module HtmlEmailCreator
  
  autoload :Email, "html_email_creator/email"
  autoload :Extensions, "html_email_creator/extensions"
  autoload :Filters, 'html_email_creator/filters'
  autoload :Helper, 'html_email_creator/helper'
  autoload :Layout, 'html_email_creator/layout'
  autoload :Markdown, 'html_email_creator/markdown'
  autoload :Processor, 'html_email_creator/processor'
  autoload :Renderer, 'html_email_creator/renderer'
  autoload :Settings, 'html_email_creator/settings'

  class << self
    attr_writer :settings    
    
    def root
      @root ||= current_root_dir
    end
    
    def current_root_dir
      Dir.pwd
    end
    
    def settings
      @settings ||= read_settings(root)
    end
    
    def update_settings
      @settings = read_settings(current_root_dir)
    end
    
    def read_settings(dir)
      Settings.new(dir)
    end
  end
end