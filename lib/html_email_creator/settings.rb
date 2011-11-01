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
      config_file = find_config_file
      if config_file
        YAML.load_file(config_file)
      else
        default_config
      end
    end
    
    def default_config
      {
        "layout_path" => find_dir("Layouts"),
        "output_path" => find_dir("Output"),
        "cdn_url" => "",
        "extensions" => []
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