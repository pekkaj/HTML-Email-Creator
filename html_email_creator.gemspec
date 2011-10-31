# -*- encoding: utf-8 -*-

require 'html_email_creator/version'

Gem::Specification.new do |s|
  s.platform           = Gem::Platform::RUBY
  s.name               = "html_email_creator"
  s.version            = HtmlEmailCreator::VERSION
  s.summary            = 'An easy way to create HTML and plain text emails!'
  s.description        = 'An easy way to create HTML and plain text emails using Markdown markup and Liquid layouts.'
  s.default_executable = "html_email_creator"

  s.required_ruby_version = '>= 1.9.2'
  s.rubygems_version      = ">= 1.3.6"
  
  s.author   = 'Pekka Mattila'
  s.email    = 'pekka.mattila@gmail.com'
  s.homepage = 'https://github.com/pekkaj/HTML-Email-Creator'
  
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables        = %w(html_email_creator)
  s.require_paths      = ["lib"]
end