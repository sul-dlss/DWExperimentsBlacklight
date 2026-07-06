# frozen_string_literal: true

module Blacklight
  module Facets
    # Overrides Blacklight's SuggestComponent to hide the visible filter label
    # (kept for screen readers) and inset the search icon on the left of the
    # input, matching the main search box.
    class SuggestComponent < Blacklight::Component
      def initialize(presenter:)
        super()
        @presenter = presenter
      end

      private

      attr_accessor :presenter

      delegate :key, :label, to: :presenter

      def render?
        presenter.suggest?
      end
    end
  end
end
