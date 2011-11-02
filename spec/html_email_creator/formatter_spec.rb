require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Formatter do
  describe "Markdown" do
    it "should convert correctly" do
      HtmlEmailCreator::Formatter.new("**I am strong**").format(:md).should eql("<p><strong>I am strong</strong></p>")
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

      HtmlEmailCreator::Formatter.new(markdown).format(:md).should eql(html.strip)
    end
  end
end