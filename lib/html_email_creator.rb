module HtmlEmailCreator
  
  autoload :Layout, 'html_email_creator/layout'
  autoload :Settings, 'html_email_creator/settings'
  autoload :Markdown, 'html_email_creator/markdown'
  
  class << self
    attr_writer :settings
    
    def root
      @root ||= current_root_dir
    end
    
    def current_root_dir
      Dir.pwd
    end
    
    def settings
      @settings ||= Settings.new(root)
    end
    
    def update_settings
      @settings = Settings.new(current_root_dir)
    end
  end
end

