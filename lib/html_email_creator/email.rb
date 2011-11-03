require "liquid"

module HtmlEmailCreator
  class Email
    attr_reader :settings
    
    def self.find_emails(file_or_directory, recursively = false)
      if File.directory?(file_or_directory)
        if recursively
          Dir.glob(File.join(file_or_directory, "**", "*.yaml"))
        else
          Dir.glob(File.join(file_or_directory, "*.yaml"))
        end
      else
        return [] unless File.extname(file_or_directory) == ".yaml"
        [file_or_directory]
      end
    end

    def initialize(configuration, settings = HtmlEmailCreator.settings)
      @configuration = if configuration.class == String
        YAML.load_file(configuration)
      else
        configuration
      end
      @settings = settings
    end
    
    def render
      layout = fill_blanks(IO.read(layout_path))
      HtmlEmailCreator::Layout.new(layout, settings.extension_data).to_html
    end
    
    def render_and_store
      output_dir = File.dirname(output_path)
      FileUtils.mkdir_p(output_dir) unless File.exists?(output_dir)
      File.open(output_path, "w") do |file|
        file.write(render)
      end
      output_path
    end
    
    private
    
    def output_path
      File.join(@settings.output_path, @configuration["config"]["output"])
    end
    
    def layout_path
      File.join(@settings.layouts_path, @configuration["config"]["layout"])
    end
    
    def fill_blanks(layout)
      filled_layout = layout.dup
      @configuration["config"]["data"].each_pair do |key, value|
        filled_layout.gsub!(/\{\{\s*#{key}\s*\}\}/, value)
      end
      filled_layout
    end
  end
end