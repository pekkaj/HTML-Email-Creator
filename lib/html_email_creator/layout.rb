require "liquid"

module HtmlEmailCreator
  module BuiltInFilters
    def photo(input, alt)
      url = "#{HtmlEmailCreator.settings.cdn_url}/#{input}"
      "<img src=\"#{url}\" alt=\"#{alt}\" border=\"0\">"
    end

    def include(input)
      "include called"
    end
  end

  class Layout
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
    
    def initialize(text, extensions = HtmlEmailCreator.settings.extensions)
      @template = Liquid::Template.parse(text)
      @default_data = read_default_data(extensions)
    end
        
    def to_html(data = {}, *filters)
      @template.render(@default_data.merge(data), :filters => [BuiltInFilters] + filters)
    end
    
    private
    
    def read_default_data(extensions)
      data = {}
      extensions.each do |extension|
        found_data = @@EXTENSIONS[extension]
        data.merge!(found_data) if found_data
      end
      data
    end
  end
end