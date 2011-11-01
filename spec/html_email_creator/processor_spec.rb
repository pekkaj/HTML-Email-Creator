require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Processor do

  let(:processor) {
    html = <<-eos
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<title>Title</title>
</head>
<body>

<style type="text/css">
.h1 div{font-family:Helvetica}
ul{margin: 5px 5px 5px 5px}
</style>

<h1>Header 1</h1>

<table class="inline">
<tr><td>col1</td><td>col2</td>
<tr><td>row 1 col 1</td><td>row 1 col 2</td>
<tr><td>row 2 col 1</td><td>row 2 col 2</td>
</table>

This is simple email with <a href="http://link1.com">link</a>

<p><img src="http://cdn.example.com/foo/bar" alt="Great image" border="0" /></p>

<p><a href="http://signup"><img src="http://cdn.example.com/foo/bar" alt="Signup" border="0" /></a></p>

<h2>Header 2</h2>

<ul>
<li>list 1</li>
<li>list 2</li>
</ul>

eos
    
    HtmlEmailCreator::Processor.new(html)
  }

  describe "#to_html" do
    let(:html) { processor.to_html }
    
    it "should wrap headers with divs" do
      html.should include('<div class="h1"><div style="font-family: Helvetica;">Header 1</div></div>')
    end
    
    it "should inline styles" do
      html.should include('<ul style="margin: 5px 5px 5px 5px;">')
    end
    
  end
  
  describe "#to_plain_text" do
    let(:text) { processor.to_plain_text }
    
    it "format plain text message in a nice way" do
      expected_output = <<-eos
=============================================================================
Header 1

col1
* row 1 col 1
* row 2 col 1

col2
* row 1 col 2
* row 2 col 2

This is simple email with link (http://link1.com)

Great image (http://cdn.example.com/foo/bar)

Signup (http://signup)

-----------------------------------------------------------------------------
Header 2

- list 1
- list 2
eos
      
      text.should eq(expected_output.strip)
    end 
  end
end