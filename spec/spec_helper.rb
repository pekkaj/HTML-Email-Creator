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
