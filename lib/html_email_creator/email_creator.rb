module HtmlEmailCreator
  class EmailCreator
    def create_email(file_or_configuration, format)
      email(file_or_configuration).render_only(format)
    end

    def create_html_email(file_or_configuration)
      email(file_or_configuration).render_html_email
    end

    def create_plain_text_email(file_or_configuration)
      email(file_or_configuration).render_plain_text_email
    end

    def create_all_email_versions(file_or_configuration)
      email(file_or_configuration).render_all
    end

    def save_email(file_or_configuration)
      formats_and_paths = {}
      create_all_email_versions(file_or_configuration).each_value do |version|
        formats_and_paths[version.id] = version.save
      end
      formats_and_paths
    end

    def save_emails(file_or_directory, recursively = false)
      files = {}
      HtmlEmailCreator::Email.find_emails(file_or_directory, recursively).each do |file|
        files[file] = save_email(file)
      end
      files
    end
    
    private
    
    def email(file_or_configuration)
      if file_or_configuration.kind_of?(String)
        # Is file so update settings before creating email (makes sure that we have the latest settings file)
        HtmlEmailCreator.update_settings(File.dirname(file_or_configuration))
      end
      Email.new(file_or_configuration, HtmlEmailCreator.settings)
    end
  end
end