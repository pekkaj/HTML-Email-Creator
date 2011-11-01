require File.join(File.dirname(__FILE__), "..", "lib", "html_email_creator")

RSpec.configure do |config|
  config.color_enabled = true
  
  config.before :each do
    ARGV.replace []
  end
end

def fixture_dir(*pathparts)
  File.join(File.dirname(__FILE__), 'fixtures', pathparts)
end

def run_in_fixture_dir(*pathparts, &block)
  current_dir = Dir.pwd
  Dir.chdir(fixture_dir(pathparts))
  HtmlEmailCreator.update_settings
  yield self if block_given?
  Dir.chdir(current_dir)
end