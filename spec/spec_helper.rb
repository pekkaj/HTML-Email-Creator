require File.join(File.dirname(__FILE__), "..", "lib", "html_email_creator")

RSpec.configure do |config|
  config.color_enabled = true
  
  config.before :each do
    ARGV.replace []
  end
end

def fixture_dir(*pathparts)
  File.join(File.dirname(__FILE__), 'fixtures', pathparts.flatten)
end

def read_fixture(*pathparts)
  IO.read(fixture_dir(pathparts))
end

def clean_fixture_output
  Dir.glob(File.join(fixture_dir, "**", "Output", "**", "*.{html,txt}")).each do |file|
    File.delete(file)
  end
end

def run_in_fixture_dir(*pathparts, &block)
  current_dir = Dir.pwd
  Dir.chdir(fixture_dir(pathparts))
  HtmlEmailCreator.update_settings
  res = yield
  Dir.chdir(current_dir)
  res
end