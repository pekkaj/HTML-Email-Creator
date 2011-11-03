module HtmlEmailCreator
  class EmailCreator
    def initialize(settings = HtmlEmailCreator.settings)
      @settings = settings
    end
    
    def create_email(file_or_configuration)
      # TODO
    end
    
    def cerate_and_store_email(file_or_configuration)
      # TODO
    end
        
    def create_emails(file_or_directory, recursively = false)
      # TODO
    end
    
    def create_and_store_emails(file_or_directory, recursively = false)
      # TODO: actually create and store
      HtmlEmailCreator::Email.find_emails(file_or_directory, recursively)
    end
  end
end