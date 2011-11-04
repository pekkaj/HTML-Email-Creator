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
      file = File.join(@settings.output_path, "#{@output_basename}.#{@formatter.extension}")
      directory = File.dirname(file)
      FileUtils.mkdir_p(directory) unless File.exists?(directory)
      File.open(file, "w") do |opened_file|
        opened_file.write(get)
      end
      file
    end
  end
end