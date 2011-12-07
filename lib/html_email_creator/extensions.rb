require 'kramdown'

module HtmlEmailCreator
  class Extensions
    @@EXTENSIONS = {
      'aweber' => {
        'email' => '{!email}',
        'subscription_date' => '{!signdate long}',
        'unsubscribe_url' => '{!remove_web}',
        'full_name' => '{!name_fix}',
        'first_name' => '{!firstname_fix}',
        'last_name' => '{!lastname_fix}',
        'signature' => '{!signature}',
        'company_address' => '{!contact_address}',
        'tomorrow' => '{!date dayname+1}',
        'after_2_days' => '{!date dayname+2}',
        'after_3_days' => '{!date dayname+3}',
        'after_4_days' => '{!date dayname+4}',
        'after_5_days' => '{!date dayname+5}',
        'after_6_days' => '{!date dayname+6}',
        'after_7_days' => '{!date dayname+7}'
      },
      'mailchimp' => {
        'first_name' => '*|FNAME|*',
        'last_name' => '*|LNAME|*',
        'unsubscribe_url' => '*|UNSUBSCRIBE|*'
      }
    }
    
    def initialize(settings = HtmlEmailCreator.settings)
      @settings = settings
    end
    
    def built_in(*extensions)
      new_data = {}
      extensions.flatten.each do |extension|
        data = @@EXTENSIONS[extension]
        new_data.merge!(data.dup) if data
      end
      new_data
    end
    
    def custom(data = {}, extensions)
      new_data = {}
      extensions.each_pair do |key, value|
        new_data[key] = value
      end
      new_data
    end
  end
end