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
    @@AWEBER_REPLACEMENTS = {
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
    
    def initialize(text)
      @template = Liquid::Template.parse(text)
    end
    
    def to_aweber_html(data = {}, *filters)
      data_with_aweber = data.merge(@@AWEBER_REPLACEMENTS)
      to_html(data_with_aweber, filters)
    end
    
    def to_html(data = {}, *filters)
      @template.render(data, :filters => [BuiltInFilters] + filters)
    end
  end
end