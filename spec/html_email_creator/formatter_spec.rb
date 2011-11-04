require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Formatter do
  describe "Markdown" do
    let(:md) { HtmlEmailCreator::Formatters::Markdown.id }
    
    it "should convert correctly" do
      HtmlEmailCreator::Formatter.new("**I am strong**").find(md).format.should eql("<p><strong>I am strong</strong></p>")
    end

    it "should not support Kramdowns table extension, since it is not compatible with Liquid filters" do
      markdown = <<-eos
| First | Second | Third |
|:------|:-------|:------|
| 1     | 2      | 3     |
      eos

      html = <<eos
<p>| First | Second | Third |
|:------|:-------|:------|
| 1     | 2      | 3     |</p>
eos

      HtmlEmailCreator::Formatter.new(markdown).find(md).format.should eql(html.strip)
    end
  end
end