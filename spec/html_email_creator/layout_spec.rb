require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Layout do
    
  describe "with custom filters and replacementes" do
        
    it "should replace filters" do
      HtmlEmailCreator::Layout.new("foo {{ bar }}").to_html("bar" => "great bar").should eql("foo great bar")
    end
  end
end