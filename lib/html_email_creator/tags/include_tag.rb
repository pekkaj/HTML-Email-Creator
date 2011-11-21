require 'liquid'

module HtmlEmailCreator

  class IncludeTag < Liquid::Tag
    Syntax = /(#{Liquid::QuotedFragment}+)(\s+(?:with|for)\s+(#{Liquid::QuotedFragment}+))?/

    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax

        @template_name = $1
        @variable_name = $3
        @attributes    = {}

        markup.scan(Liquid::TagAttributes) do |key, value|
          @attributes[key] = value
        end

      else
        raise SyntaxError.new("Error in tag 'include' - Valid syntax: include '[template]' (with|for) [object|collection]")
      end

      super
    end

    def parse(tokens)
    end

    def render(context)
      settings = find_settings(context)
      source = read_template_from_file_system(context, settings)
      partial = Liquid::Template.parse(source)
      variable = context[@variable_name || @template_name[1..-2]]

      context.stack do
        @attributes.each do |key, value|
          context[key] = context[value]
        end

        if variable.is_a?(Array)
          variable.collect do |variable|
            context[@template_name[1..-2]] = variable
            partial.render(context)
          end
        else
          context[@template_name[1..-2]] = variable
          partial.render(context)
        end
      end
    end

    private

    def find_settings(context)
      (context.registers[:settings] || HtmlEmailCreator.settings)
    end

    def read_template_from_file_system(context, settings)
      template = File.join(settings.includes_path, context[@template_name])
      if File.exists?(template)
        # run through a formatter
        formatter = HtmlEmailCreator::Formatter.new(IO.read(template), settings)
        settings.fill_extension_data(formatter.find_by_filename(template).format)
      else
        "Included file '#{template}' not found."
      end
    end
  end

  Liquid::Template.register_tag('include', IncludeTag)
end