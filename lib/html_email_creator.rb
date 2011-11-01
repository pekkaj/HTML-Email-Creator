module HtmlEmailCreator
  
  autoload :Layout, 'html_email_creator/layout'
  autoload :Settings, 'html_email_creator/settings'
  autoload :Markdown, 'html_email_creator/markdown'
  
  class << self
    def root_dir
      Dir.pwd
    end
    
    def settings
      @settings ||= Settings.new(root_dir)
    end
  end
end

