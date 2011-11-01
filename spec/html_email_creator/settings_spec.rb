require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Settings do
    
  describe "default settings" do
    before(:all) do
      @home_directory = File.expand_path('~')
      @default_settings = HtmlEmailCreator::Settings.new
    end  

    it "should return user's home directory based email directory" do
      @default_settings.emails_path.should eql(File.join(@home_directory, "Emails"))
    end

    it "should return user's home directory based layouts directory" do
      @default_settings.layouts_path.should eql(File.join(@home_directory, "Layouts"))
    end

    it "should return user's home directory based output directory" do
      @default_settings.output_path.should eql(File.join(@home_directory, "Output"))
    end

    it "should return empty CDN url" do
      @default_settings.cdn_url.should eql("")
    end

    it "should return extension list" do
      @default_settings.extension_data.should eql({})
    end
  end

  describe "finding default directories" do
    before(:all) do
      @default_settings = HtmlEmailCreator::Settings.new(fixture_dir("default_config", "Emails", "Newsletter"))
    end  

    it "should find Layout directory recursively" do
      @default_settings.emails_path.should eql(fixture_dir("default_config", "Emails"))
    end

    it "should find Layout directory recursively" do
      @default_settings.layouts_path.should eql(fixture_dir("default_config", "Layouts"))
    end

    it "should find Output directory recursively" do
      @default_settings.output_path.should eql(fixture_dir("default_config", "Output"))
    end
  end
  
  describe "finding settings from the file system" do

    it "should find the configuration recursively from leaf to root" do
      HtmlEmailCreator::Settings.new(fixture_dir).cdn_url.should eql("") # not found
      HtmlEmailCreator::Settings.new(fixture_dir("with_config")).cdn_url.should eql("http://cdn.example.com") # found
      HtmlEmailCreator::Settings.new(fixture_dir("with_config", "Layout")).cdn_url.should eql("http://cdn.example.com") # found
    end

    it "should find the configuration recursively from the current directory to root" do
      Dir.chdir(fixture_dir("with_config"))
      HtmlEmailCreator.update_settings
      HtmlEmailCreator.settings.cdn_url.should eql("http://cdn.example.com") # found
    end
    
    it "should use defaults if the directory could not be found from the current directory or any root directories" do
      Dir.chdir(File.dirname(__FILE__))
      HtmlEmailCreator.update_settings
      HtmlEmailCreator.settings.cdn_url.should eql("") # not found
    end
  end
end