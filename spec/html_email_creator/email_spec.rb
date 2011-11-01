require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Email do

  after(:each) do
    # cleanup
  end
    
  it "render markdown and liquid templates using settings and email configuration" do
    run_in_fixture_dir("with_config") do
      expected_template = <<-eos
<p>This is simple template.</p>

<p>foo bar</p>

<p>bar foo</p>

<p><img src="http://cdn.example.com/foo/bar" alt="alt text" border="0" /></p>
      eos
      
      email = fixture_dir("with_config", "Emails", "first_email.yaml")
      HtmlEmailCreator::Email.new(email).render.should eql(expected_template)
    end
  end    
end