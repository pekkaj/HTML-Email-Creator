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

    def layouts_path
      @config["layouts_path"]
    end

    def output_path
      @config["output_path"]
    end

    def emails_path
      @config["emails_path"]
    end

    def includes_path
      @config["includes_path"]
    end

    def cdn_url
      @config["cdn_url"]
    end

    def fill_extension_data(source)
      filled = source.dup

      extension_data.each_pair do |key, value|
        filled.gsub!(/\{\{\s*#{key}\s*\}\}/, value)
      end

      filled
    end

    def extension_data
      return @extension_data if @extension_data
      extensions = HtmlEmailCreator::Extensions.new
      built_in_data = extensions.built_in(built_in_extensions)
      # use built in data for creating custom data
      custom_data = extensions.custom(built_in_data, custom_extensions)
      @extension_data = built_in_data.merge(custom_data)
    end

    def built_in_extensions
      (@config["extensions"] || {})["built_in"] || []
    end
    
    private

    def custom_extensions
      (@config["extensions"] || {})["custom"] || {}
    end

    def create_configuration
      config_file = find_config_file
      if config_file
        config_root_dir = File.dirname(config_file)
        loaded_config = YAML.load_file(config_file)
        # fill missing values with defaults if missing
        default_config.each_pair do |key, value|
          loaded_config[key] = value unless loaded_config[key]
        end

        # make absolute paths if is relative for all _path ending keys
        loaded_config.each_pair do |key, value|
          if key.match(/_path$/) && !value.match(/^\//)
            loaded_config[key] = File.join(config_root_dir, value)
          end
        end

        loaded_config
      else
        default_config
      end
    end

    def default_config
      {
        "layouts_path" => find_dir("Layouts"),
        "output_path" => find_dir("Output"),
        "emails_path" => find_dir("Emails"),
        "includes_path" => find_dir("Includes"),
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