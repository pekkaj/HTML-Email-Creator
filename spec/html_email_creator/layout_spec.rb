require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Layout do
    
  describe "with custom variables" do
    it "should replace variables" do
      HtmlEmailCreator::Layout.new("foo {{ bar }}").to_html("bar" => "great bar").should eql("foo great bar")
    end
    
    it "should just ignore the variable if the variable was not found" do
      HtmlEmailCreator::Layout.new("foo {{ bar }}").to_html.should eql("foo ")
    end
  end
  
  describe "with aweber mail" do
    it "should replace Aweber variables correctly" do
      HtmlEmailCreator::Layout.new("{{ after_7_days }}").to_aweber_html().should eql('{!date dayname+7}')
    end
  end
  
  describe "with built-in filters" do
    
    before(:each) do
      Dir.chdir(fixture_dir("with_config"))
      HtmlEmailCreator.update_settings
    end
    
    it "should generate photo url correctly" do
      markdown = '{{ "hello/world.jpg" | photo: "Custom alt text" }}'
      output = '<img src="http://cdn.example.com/hello/world.jpg" alt="Custom alt text" border="0">'
      HtmlEmailCreator::Layout.new(markdown).to_html.should eql(output)
    end
    
  end
end