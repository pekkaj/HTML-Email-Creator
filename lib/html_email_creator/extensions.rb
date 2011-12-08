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
        'email' => '*|EMAIL|*',
        'first_name' => '*|FNAME|*',
        'last_name' => '*|LNAME|*',
        'unsubscribe_url' => '*|UNSUBSCRIBE|*'
      }
    }

    # This is a mechanism for handling HTML email for certain extension

    def initialize()
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

    # HTML callback after the HTML is created.
    def process_html(html, *extensions)
      processed_html = html.dup

      extensions.each do |extension|
        method_name = "process_html_for_#{extension}".to_sym

        if self.respond_to?(method_name)
          processed_html = self.send(method_name, method_name)
        end
      end

      processed_html
    end

    private

    def process_html_for_aweber(html)
      html.gsub(/%7B/, '{').gsub(/%7D/, '}').gsub(/!global%20/, '!global ')
    end

    def process_html_for_mailchimp(html)
      html.gsub(/%7/, '|')
    end

  end
end