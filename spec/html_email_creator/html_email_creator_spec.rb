require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "HTML Email Creator at high level" do

  let(:email) {
    run_in_fixture_dir("complex_with_config") do
      email_file = fixture_dir("complex_with_config", "Emails", "polite_email.yaml")
      rendered_email = HtmlEmailCreator::Email.new(email_file).render
      HtmlEmailCreator::Processor.new(rendered_email)
    end
  }

  describe "HTML mail" do
    let(:html) { email.to_html }
    let(:expected_html) {
      html = <<eos
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>A variant</title>
</head>
<body>

<div class="h1"><div style="font-family: Helvetica;">Header 1 starts</div></div>

Hi {!name_fix},

**Logo**: WOHOO.

<div class="h2"><div>Header 2 starts</div></div>

<p>I really love iPhone. GREAT!</p>

</body>
</html>
eos
      html
    }
    
    it "should be created correctly" do
      html.should == expected_html
    end
  end
  
  describe "Plain text mail" do
    let(:plain_text) { email.to_plain_text }
    let(:expected_plain_text) {
      text = <<eos
=============================================================================
Header 1 starts

Hi {!name_fix},

**Logo**: WOHOO.

-----------------------------------------------------------------------------
Header 2 starts

I really love iPhone. GREAT!   
eos
      text.strip
    }

    it "should create corrent plain text email" do
      plain_text.should == expected_plain_text
    end
  end
end