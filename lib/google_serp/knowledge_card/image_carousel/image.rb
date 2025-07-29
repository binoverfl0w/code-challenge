# frozen_string_literal: true

require 'json'

module GoogleSerp
  module KnowledgeCard
    class ImageCarousel
      # Represents an image in the image carousel of a knowledge card.
      class Image
        attr_reader :name, :extensions, :link, :image

        def initialize(name:, extensions:, link:, image:)
          @name = name
          @extensions = extensions
          @link = link
          @image = image
        end

        def to_json(*_args)
          {
            name: @name,
            extensions: @extensions,
            link: @link,
            image: @image
          }.to_json
        end

        def to_s
          to_json
        end
      end
    end
  end
end
