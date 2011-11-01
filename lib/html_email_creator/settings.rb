module HtmlEmailCreator
  class Settings
    
    # Create settings configuration file.
    # 
    # If the root is not set, the configuration is not searched from the file system
    # but instead the defaults are used.
    def initialize(root = nil)
      @root = root
      @root ||= File.expand_path('~')
      @config = create_configuration      
    end
    
    def emails_path
      @config["emails_path"]
    end
    
    def layouts_path
      @config["layouts_path"]
    end
    
    def output_path
      @config["output_path"]
    end

    def cdn_url
      @config["cdn_url"]
    end
    
    def extensions
      return @extension_data if @extension_data
      built_in = HtmlEmailCreator::Extensions.built_in((@config["extensions"] || {})["built_in"])
      custom = HtmlEmailCreator::Extensions.built_in((@config["extensions"] || {})["custom"])
      @extension_data = built_in.merge(custom)
    end

    private

    def create_configuration
      config_file = find_config_file
      if config_file
        YAML.load_file(config_file)
      else
        default_config
      end
    end
    
    def default_config
      {
        "layouts_path" => find_dir("Layouts"),
        "output_path" => find_dir("Output"),
        "emails_path" => find_dir("Emails"),
        "cdn_url" => "",
        "extensions" => {}
      }
    end
    
    def find_dir(dir)
      HtmlEmailCreator::Helper.find_recursively(@root, dir, File.join(@root, dir))
    end
              
    def find_config_file
      HtmlEmailCreator::Helper.find_recursively(@root, ".html_config.yaml")
    end
  end
end