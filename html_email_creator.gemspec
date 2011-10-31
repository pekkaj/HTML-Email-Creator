# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

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
  s.rubyforge_project     = "html_email_creator"
  
  s.author   = 'Pekka Mattila'
  s.email    = 'pekka.mattila@gmail.com'
  s.homepage = 'https://github.com/pekkaj/HTML-Email-Creator'
  
  git_files            = `git ls-files`.split("\n") rescue ''
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables        << 'html_email_creator'
  s.files              = git_files
  s.require_paths      = ["lib"]
end