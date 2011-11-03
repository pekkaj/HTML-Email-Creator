# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'html_email_creator/version'
require 'html_email_creator/information'

Gem::Specification.new do |s|
  s.platform           = Gem::Platform::RUBY
  s.name               = "html_email_creator"
  s.version            = HtmlEmailCreator::VERSION
  s.summary            = HtmlEmailCreator::SUMMARY
  s.description        = HtmlEmailCreator::DESCRIPTION
  s.default_executable = "html_email_creator"

  s.required_ruby_version = '>= 1.9.2'
  s.rubygems_version      = ">= 1.3.6"
  s.rubyforge_project     = "html_email_creator"
  
  s.author   = 'Pekka Mattila'
  s.email    = 'pekka.mattila@gmail.com'
  s.homepage = 'https://github.com/pekkaj/HTML-Email-Creator'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # Runtime Dependencies

  s.add_runtime_dependency "commander", ">= 4.0.6"
  s.add_runtime_dependency "kramdown", ">= 0.13.3"
  s.add_runtime_dependency "liquid", ">= 2.3.0"
  s.add_runtime_dependency "nokogiri", ">= 1.5.0"
  s.add_runtime_dependency "inline-style", ">= 0.5.0"
  
  # Development Dependencies
  
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake", ">= 0.9.2"
end