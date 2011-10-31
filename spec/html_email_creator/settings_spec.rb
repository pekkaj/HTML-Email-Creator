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
  end
end