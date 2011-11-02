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
      source = read_template_from_file_system(context)
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

    def read_template_from_file_system(context)
      template = template_path(context)
      if File.exists?(template)
        IO.read(template)
      else
        "Included file '#{template}' not found."
      end
    end
    
    def template_path(context)
      includes_dir = (context.registers[:settings] || HtmlEmailCreator.settings).includes_path
      full_path = File.join(includes_dir, context[@template_name])
      File.join(File.dirname(full_path), "_#{File.basename(full_path)}.liquid")      
    end

  end

  Liquid::Template.register_tag('include', IncludeTag)
end