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
        'company_signature' => '{!signature}',
        'company_address' => '{!contact_address}',
        'tomorrow' => '{!date dayname+1}',
        'after_2_days' => '{!date dayname+2}',
        'after_3_days' => '{!date dayname+3}',
        'after_4_days' => '{!date dayname+4}',
        'after_5_days' => '{!date dayname+5}',
        'after_6_days' => '{!date dayname+6}',
        'after_7_days' => '{!date dayname+7}'
      }
    }
    
    def built_in(*extensions)
      data = {}
      extensions.each do |extension|
        data.merge(@@EXTENSIONS[extension] || {})
      end
      data
    end
    
    def custom(*extensions)
      # TODO
      {}
    end
  end
end