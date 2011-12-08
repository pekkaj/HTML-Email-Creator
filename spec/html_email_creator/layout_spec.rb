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

  describe "with built-in extensions" do

    describe "aweber" do
      let(:aweber) { HtmlEmailCreator::Extensions.new.built_in("aweber") }
      let(:none) { {} }

      it "should replace Aweber extension keys correctly if aweber extension is being used" do
        HtmlEmailCreator::Layout.new("{{ after_7_days }}", aweber).to_html.should eql('{!date dayname+7}')
        HtmlEmailCreator::Layout.new("{{ after_7_days }}", none).to_html.should eql('')
      end

      it "should replace Aweber extension keys correctly if aweber extension is being used in settings" do
        run_in_fixture_dir("with_config") do
          HtmlEmailCreator::Layout.new("{{ after_7_days }}").to_html.should eql('{!date dayname+7}')
        end
      end
    end
    
    describe "mailchimp" do
      let(:mailchimp) { HtmlEmailCreator::Extensions.new.built_in("mailchimp") }
      let(:none) { {} }

      it "should replace Mailchimp extension keys correctly if aweber extension is being used" do
        HtmlEmailCreator::Layout.new("{{ first_name }}", mailchimp).to_html.should eql('*|FNAME|*')
        HtmlEmailCreator::Layout.new("{{ last_name }}", none).to_html.should eql('')
      end
    end
  end

  describe "with custom extensions" do

    it "should replace custom extension keys correctly use custom extensions from configuration to render the layout" do
      run_in_fixture_dir("with_config") do
        HtmlEmailCreator::Layout.new("{{ foobar }}").to_html.should eql('Hi, this is foobar.')
        HtmlEmailCreator::Layout.new("{{ great }}").to_html.should eql('Hi, this is **great**')
      end
    end
  end

  describe "with built-in filters" do

    it "should generate photo url correctly" do
      run_in_fixture_dir("with_config") do
        markdown = '{{ "hello/world.jpg" | photo: "Custom alt text" }}'
        output = '<img src="http://cdn.example.com/hello/world.jpg" alt="Custom alt text" border="0" />'
        HtmlEmailCreator::Layout.new(markdown).to_html.should eql(output)
      end
    end

    it "should generate download url correctly" do
      run_in_fixture_dir("with_config") do
        markdown = '{{ "book.pdf" | download: "Download cool book" }}'
        output = '<a href="http://cdn.example.com/book.pdf">Download cool book</a>'
        HtmlEmailCreator::Layout.new(markdown).to_html.should eql(output)
      end
    end
  end
end