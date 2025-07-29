# frozen_string_literal: true

require_relative 'lib/google_serp/version'

Gem::Specification.new do |spec|
  spec.name = 'google_serp'
  spec.version = GoogleSerp::VERSION
  spec.authors = ['binoverfl0w']
  spec.email = ['arjanmarku02@gmail.com']

  spec.description = 'Google SERP Scraper is a Ruby gem that allows you to scrape a subset of data from Google Search Engine Results Pages (SERPs) like knowledge cards. It provides a simple and efficient way to extract structured information from Google search results.'
  spec.summary = spec.description
  spec.homepage = 'https://github.com/binoverfl0w/code-challenge'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1.18.9'
end
