module HtmlEmailCreator
  class EmailVersion    
    def initialize(formatter, output_basename, settings)
      @formatter = formatter
      @output_basename = output_basename
      @settings = settings
    end

    def get
      @formatter.format
    end
    
    def id
      @formatter.id
    end

    def save
      FileUtils.mkdir_p(@settings.output_path) unless File.exists?(@settings.output_path)
      file = File.join(@settings.output_path, "#{@output_basename}.#{@formatter.extension}")
      File.open(file, "w") do |file|
        file.write(get)
      end
      file
    end
  end
end