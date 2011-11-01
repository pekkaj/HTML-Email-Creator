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
    let(:aweber) { HtmlEmailCreator::Extensions.new.built_in("aweber") }
    let(:none) { {} }
    
    it "should replace Aweber variables correctly if aweber extension exists" do      
      HtmlEmailCreator::Layout.new("{{ after_7_days }}", aweber).to_html.should eql('{!date dayname+7}')
      HtmlEmailCreator::Layout.new("{{ after_7_days }}", none).to_html.should eql('')
    end

    it "should replace Aweber variables correctly if aweber extension exists in settings" do
      run_in_fixture_dir("with_config") do
        HtmlEmailCreator::Layout.new("{{ after_7_days }}").to_html.should eql('{!date dayname+7}')
      end
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