require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Settings do
    
  describe "default settings" do
    before(:all) do
      @home_directory = File.expand_path('~')
      @default_settings = HtmlEmailCreator::Settings.new
    end  

    it "should return user's home directory based layouts directory" do
      @default_settings.layout_path.should eql(File.join(@home_directory, "layouts"))
    end

    it "should return user's home directory based output directory" do
      @default_settings.output_path.should eql(File.join(@home_directory, "output"))
    end

    it "should return empty CDN url" do
      @default_settings.cdn_url.should eql("")
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