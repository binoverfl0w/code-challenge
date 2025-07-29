# frozen_string_literal: true

require_relative 'knowledge_card/image_carousel'
require_relative 'knowledge_card/image_carousel/image'
require 'nokogiri'

module GoogleSerp
  # The KnowledgeCard module provides methods to extract and build knowledge card elements
  module KnowledgeCard
    class ElementNotFoundError < StandardError; end

    # Builds an ImageCarousel from the given Nokogiri node.
    # @param element [Nokogiri::XML::Node] The Nokogiri node containing the knowledge card.
    # @return [ImageCarousel] The constructed ImageCarousel object.
    # @raise [ElementNotFoundError] If no carousel container is found in the document
    def build_image_carousel(element)
      # CSS selector to find the knowledge card container
      carousel_container = element.css('div[data-attrid^="kc:/"]').first
      raise ElementNotFoundError, 'No carousel container found in the document' if carousel_container.nil?

      images = []
      carousel_container.css('a').each do |anchor_element|
        images << build_image(anchor_element, element.css('script'))
      rescue ElementNotFoundError => _e
        # Ignored
      end
      ImageCarousel.new(images: images)
    end

    # Builds an Image object from the given Nokogiri node.
    # @param element [Nokogiri::XML::Node] The Nokogiri node containing the image information.
    # @return [ImageCarousel::Image] The constructed Image object.
    # @raise [ElementNotFoundError] If no image is found in the given node
    def build_image(element, scripts)
      image_element = element.css('img').first
      raise ElementNotFoundError, 'No image found in the given node' if image_element.nil?

      text_nodes = element.xpath('.//text()').map(&:text).reject(&:empty?)
      name = text_nodes.shift.strip
      extensions = text_nodes.empty? ? nil : text_nodes.map(&:strip)
      href = element['href']
      link = !href.start_with?('http') ? "https://www.google.com#{href}" : href
      # choose data-src if it is available in the image element, otherwise attempt to resolve it from the script
      # before falling back to the src attribute.
      src = image_element['data-src'] || resolve_image_src_from_script(image_element, scripts) || image_element['src']
      ImageCarousel::Image.new(name: name, extensions: extensions, link: link, image: src)
    end

    # Resolves the image source from the script content if the image src is not directly available.
    # @param img [Nokogiri::XML::Node] The image node containing the id.
    # @param scripts [Array<Nokogiri::XML::Node>] The set of script nodes to search for the image source.
    # @return [String] The resolved image source URL or the original src if not found in scripts.
    def resolve_image_src_from_script(img, scripts)
      # The script has the following format:
      # (function(){var s="<image data>";var ii=['image_id'];...;_setImagesSrc(ii, s, ...);})();
      scripts.each do |script|
        next unless script.content.include?(img['id'])

        # Since _setImagesSrc is a function that may have overloads, we care only about the left part of the function
        # until the second argument, which is the source of the image.
        match = script.content.match(/_setImagesSrc\([^,]+,\s*([^,)]+)/)
        next unless match

        source_var_name = match[1].strip
        # The source variable is defined in the script, e.g., var s="<image data>"';
        regex = Regexp.new("\\s+#{source_var_name}\\s*=\\s*['\"]([^'\"]*)['\"]")
        source_match = script.content.match(regex)
        next unless source_match && !source_match[1].empty?

        # The source may contain hex sequences, so we need to undump it.
        return "\"#{source_match[1]}\"".undump
      end

      nil
    end

    module_function :build_image_carousel, :build_image, :resolve_image_src_from_script
  end
end
