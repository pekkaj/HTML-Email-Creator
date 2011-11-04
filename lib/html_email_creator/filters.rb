require "liquid"

module HtmlEmailCreator
  module Filters
    def photo(input, alt)
      "<img src=\"#{HtmlEmailCreator.settings.cdn_url}/#{input}\" alt=\"#{alt}\" border=\"0\" />"
    end

    def download(input, text)
      "<a href=\"#{HtmlEmailCreator.settings.cdn_url}/#{input}\">#{text}</a>"
    end
  end
end