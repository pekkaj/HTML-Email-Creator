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
    
    def layout_path
      @config["layout_path"]
    end
    
    def output_path
      @config["output_path"]
    end

    def cdn_url
      @config["cdn_url"]
    end
    
    def extensions
      @config["extensions"]
    end

    private

    def create_configuration
      config_file = find_config_file(@root)
      if config_file
        YAML.load_file(config_file)
      else
        default_config
      end
    end
    
    def default_config
      {
        "layout_path" => File.join(@root, "layouts"),
        "output_path" => File.join(@root, "output"),
        "cdn_url" => "",
        "extensions" => []
      }
    end
    
    def find_config_file(start_from)
      current_file = File.join(start_from, ".html_config.yaml")
      if File.exists?(current_file)
        current_file
      else
        next_file = File.dirname(start_from)
        if start_from == next_file
          return nil
        end
        
        # continue searching
        find_config_file(next_file)
      end      
    end
  end
end