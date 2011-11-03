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
      @settings = settings
      @configuration = create_configuration(configuration)
    end

    # Renders emails using configuration. Returns Hash[format, EmailVersion].
    def render_all
      # render only once
      return @versions if @versions

      @versions = {}
      output_formats.each do |format|
        @versions[format] = render_only(format)
      end
      @versions
    end
    
    # Renders email in a specific format
    def render_only(format)
      formatter = HtmlEmailCreator::Formatter.new(rendered_email, @settings).find(format)
      HtmlEmailCreator::EmailVersion.new(formatter, output_basename, @settings)
    end
    
    # Convenience method for rendering HTML email.
    def render_html_email
      render_only(HtmlEmailCreator::Formatters::HtmlEmail.id)
    end
    
    # Convenience method for rendering plain text email.
    def render_plain_text_email
      render_only(HtmlEmailCreator::Formatters::PlainTextEmail.id)
    end
    
    private

    def rendered_email
      @email ||= HtmlEmailCreator::Layout.new(fill_blanks(IO.read(layout_path)), settings.extension_data).to_html
    end

    def output_formats
      @configuration["output_formats"]
    end

    def create_configuration(configuration)
      config_hash = if configuration.kind_of?(String)
        YAML.load_file(configuration)
      else
        configuration
      end
      
      defaults = {
        "output_formats" => ["plain_text_email", "html_email"]
      }
      
      config_hash.merge(defaults)
    end
    
    def output_basename
      @configuration["config"]["output"]
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