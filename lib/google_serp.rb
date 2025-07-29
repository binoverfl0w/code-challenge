# frozen_string_literal: true

require_relative 'google_serp/knowledge_card'
require_relative 'google_serp/knowledge_card/image_carousel'
require 'nokogiri'
require 'open-uri'

# GoogleSerp is a module that provides functionality to parse Google SERP pages
module GoogleSerp
  # Parses the given URI and extracts the knowledge card image carousel.
  # @param uri [String] The URI of the Google SERP page to parse.
  # @return [GoogleSerp::KnowledgeCard::ImageCarousel] The image carousel extracted from the knowledge card.
  # @raise [StandardError] If no search results are found, or if the document cannot be parsed.
  # @example
  #   GoogleSerp.parse('https://www.google.com/search?q=van+gogh+paintings')
  #   # => Returns a GoogleSerp::KnowledgeCard
  def parse(uri)
    doc = Nokogiri::HTML(URI.open(uri))
    search_results = doc.at_xpath('//div[h1[text()="Search Results"]]')
    raise 'No search results found' if search_results.nil?

    KnowledgeCard.build_image_carousel(search_results)
  end

  module_function :parse
end
