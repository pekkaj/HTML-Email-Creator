require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HtmlEmailCreator::Email do

  before(:each) do
    @email = fixture_dir("with_config", "Emails", "first_email.yaml")
    @expected_html = <<-eos
<p>This is simple template.</p>

<p>foo bar</p>

<p>bar foo</p>

<p><img src="http://cdn.example.com/foo/bar" alt="alt text" border="0" /></p>
    eos
  end

  after(:each) do
    html_files = File.join(fixture_dir("with_config"), "**", "*.html")
    Dir.glob(html_files).each do |file|
      File.delete(file)
    end
  end

  it "should render markdown and liquid templates using settings and email configuration" do
    run_in_fixture_dir("with_config") do
      HtmlEmailCreator::Email.new(@email).render.should eql(@expected_html)
    end
  end

  it "should store rendered markdown and liquid templates using settings and email configuration to file system" do
    run_in_fixture_dir("with_config") do
      IO.read(HtmlEmailCreator::Email.new(@email).render_and_store).should eql(@expected_html)
    end
  end

  it "should store the rendered output to the output directory specified in the settings" do
    run_in_fixture_dir("with_config") do
      HtmlEmailCreator::Email.new(@email).render_and_store.should eql(File.join(HtmlEmailCreator.settings.output_path, "first.html"))
    end
  end
end