# frozen_string_literal: true

require_relative 'image_carousel/image'

module GoogleSerp
  module KnowledgeCard
    # Represents an image carousel tab in the knowledge card of a Google SERP.
    class ImageCarousel
      attr_reader :images

      def initialize(images:)
        @images = images
      end

      def to_json(*_args)
        JSON.generate(@images)
      end

      def to_s
        to_json
      end
    end
  end
end
