require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Markdown do
    
  describe "Markdown conversion to HTML" do
    it "should convert correctly" do
      HtmlEmailCreator::Markdown.new("**I am strong**").to_html.should eql("<p><strong>I am strong</strong></p>\n")
    end
    
    it "should support table extension" do
      markdown = <<-eos
| First | Second | Third |
|:------|:-------|:------|
| 1     | 2      | 3     |
      eos
      
      html = <<eos
<table>
  <thead>
    <tr>
      <th style="text-align: left">First</th>
      <th style="text-align: left">Second</th>
      <th style="text-align: left">Third</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: left">1</td>
      <td style="text-align: left">2</td>
      <td style="text-align: left">3</td>
    </tr>
  </tbody>
</table>
eos
      
      HtmlEmailCreator::Markdown.new(markdown).to_html.should eql(html)
    end
  end
end