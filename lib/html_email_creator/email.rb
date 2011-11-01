require "liquid"

module HtmlEmailCreator
  class Email
    attr_reader :settings
    
    def initialize(configuration, settings = HtmlEmailCreator.settings)
      @configuration = if configuration.class == String
        YAML.load_file(configuration)
      else
        configuration
      end
      @settings = settings
    end
    
    def render
      data = collect_and_render_template_data
      text = IO.read(layout_path)
      HtmlEmailCreator::Renderer.new(text).to_html(data)
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
    
    def extensions
      @settings.extensions
    end
    
    def collect_and_render_template_data
      data = {}
      @configuration["config"]["data"].each_pair do |key, value|
        template = ""
        if value["inline"]
          template = value["inline"]
        elsif value["file"]
          template = IO.read(File.join(@settings.emails_path, value["file"]))
        else
          raise "Data must have either inline or file configuration"
        end
        data[key] = HtmlEmailCreator::Renderer.new(template).to_html
      end
      data
    end
  end
end