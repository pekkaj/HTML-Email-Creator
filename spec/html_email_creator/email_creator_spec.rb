require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::EmailCreator do
  let(:creator) { HtmlEmailCreator::EmailCreator.new }
  let(:aweber_email) { fixture_dir("complex_with_config", "Emails", "Aweber", "polite_email.yaml") }
  let(:mailchimp_email) { fixture_dir("complex_with_config", "Emails", "Mailchimp", "polite_email.yaml") }
  let(:expected_basic_text_html_aweber) {
    html = <<eos
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>A variant</title>
</head>
<body>

<div class="h1"><div style="font-family: Helvetica;">Header 1 starts</div></div>

Hi {!firstname_fix},

**Logo**: WOHOO.

<div class="h2"><div>Header 2 starts</div></div>

<p>{!firstname_fix}, I really love iPhone. GREAT!</p>

</body>
</html>
eos
  }

  let(:expected_basic_text_html_mailchimp) {
    html = <<eos
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>A variant</title>
</head>
<body>

<div class="h1"><div style="font-family: Helvetica;">Header 1 starts</div></div>

Hi *|FNAME|*,

**Logo**: WOHOO.

<div class="h2"><div>Header 2 starts</div></div>

<p>*|FNAME|*, I really love iPhone. GREAT!</p>

</body>
</html>
eos
  }

  let(:expected_basic_text_txt_aweber) {
    text = <<eos
=============================================================================
Header 1 starts

Hi {!firstname_fix},

**Logo**: WOHOO.

-----------------------------------------------------------------------------
Header 2 starts

{!firstname_fix}, I really love iPhone. GREAT!
eos
    text.strip
  }

  let(:expected_basic_text_txt_mailchimp) {
    text = <<eos
=============================================================================
Header 1 starts

Hi *|FNAME|*,

**Logo**: WOHOO.

-----------------------------------------------------------------------------
Header 2 starts

*|FNAME|*, I really love iPhone. GREAT!
eos
    text.strip
  }

  let(:expected_first_html) {
      html = <<eos
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><body>
<p>This is simple template.

</p>
<p>foo bar</p>

<p>bar foo</p>

<img src="http://cdn.example.com/foo/bar" alt="alt text" border="0">
</body></html>
eos
  }

  let(:expected_first_txt) {
    text = <<eos
This is simple template.

foo bar

bar foo

alt text (http://cdn.example.com/foo/bar)
eos
      text.strip
    }

  describe "HTML mail" do
    it "should create well formed and expected HTML mail for Aweber" do
      creator.create_html_email(aweber_email).get.should == expected_basic_text_html_aweber
      creator.create_email(aweber_email, HtmlEmailCreator::Formatters::HtmlEmail.id).get.should == expected_basic_text_html_aweber
    end

    it "should create well formed and expected HTML mail for Mailchimp" do
      creator.create_html_email(mailchimp_email).get.should == expected_basic_text_html_mailchimp
      creator.create_email(mailchimp_email, HtmlEmailCreator::Formatters::HtmlEmail.id).get.should == expected_basic_text_html_mailchimp
    end
  end

  describe "Plain text mail" do
    it "should create well formed and expected plain text email for Aweber" do
      creator.create_plain_text_email(aweber_email).get.should == expected_basic_text_txt_aweber
    end

    it "should create well formed and expected plain text email for Mailchimp" do
      creator.create_plain_text_email(mailchimp_email).get.should == expected_basic_text_txt_mailchimp
    end
  end

  describe "Saving email to a filesystem" do
    after(:each) { clean_fixture_output }

    it "should be possible to store emails recursively" do
      creator.save_emails(".").should be_empty
      creator.save_emails(".", true).should_not be_empty
    end

    it "should store all correct versions of emails recursively" do
      emails = creator.save_emails(".", true)

      read_fixture("complex_with_config", "Output", "Aweber", "cool", "basic_text.html").should == expected_basic_text_html_aweber
      read_fixture("complex_with_config", "Output", "Aweber", "cool", "basic_text.txt").should == expected_basic_text_txt_aweber
      read_fixture("complex_with_config", "Output", "Mailchimp", "cool", "basic_text.html").should == expected_basic_text_html_mailchimp
      read_fixture("complex_with_config", "Output", "Mailchimp", "cool", "basic_text.txt").should == expected_basic_text_txt_mailchimp
      read_fixture("with_config", "Output", "first.html").should == expected_first_html
      read_fixture("with_config", "Output", "first.txt").should == expected_first_txt
    end

    it "should store only one file if needed using absolute paths" do
      IO.read(creator.create_html_email(fixture_dir("complex_with_config", "Emails", "Aweber", "polite_email.yaml")).save).should == expected_basic_text_html_aweber
    end

    it "should store only one file if needed using relative paths" do
      run_in_fixture_dir("complex_with_config") do
        email_creator = HtmlEmailCreator::EmailCreator.new
        IO.read(email_creator.create_html_email(File.join("Emails", "Aweber", "polite_email.yaml")).save).should == expected_basic_text_html_aweber
      end
    end
  end
end

