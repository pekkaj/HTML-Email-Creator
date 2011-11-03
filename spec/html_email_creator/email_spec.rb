require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Email do
  let(:email) { 
    HtmlEmailCreator::Email.new(fixture_dir("with_config", "Emails", "first_email.yaml")).render_only(:html_email)
  }

  let(:expected_html) {
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

  it "should render markdown and liquid templates using settings and email configuration" do
    run_in_fixture_dir("with_config") do
      email.get.should eql(expected_html)
    end
  end
end