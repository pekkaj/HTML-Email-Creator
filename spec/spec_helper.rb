require File.join(File.dirname(__FILE__), "..", "lib", "html_email_creator")

RSpec.configure do |config|
  config.color_enabled = true
  
  config.before :each do
    ARGV.replace []
  end

  def source_root
    File.join(File.dirname(__FILE__), 'fixtures')
  end
end