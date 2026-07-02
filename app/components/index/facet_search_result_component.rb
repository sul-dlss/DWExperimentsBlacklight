# frozen_string_literal: true

module Index
  # Renders the filtered facet values returned into the facet search turbo frame.
  class FacetSearchResultComponent < Blacklight::Facets::ListComponent
    def initialize(id: nil, classes: [], **)
      super(**)
      @id = id
      @classes = classes
    end

    # Don't show already-applied values in the suggestions.
    def facet_item_presenters
      super.reject(&:selected?)
    end

    def render?
      true
    end
  end
end
