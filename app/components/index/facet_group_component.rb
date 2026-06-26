# frozen_string_literal: true

module Index
  class FacetGroupComponent < Blacklight::Response::FacetGroupComponent
    def initialize(id:, title: nil, body_classes: 'facets-collapse accordion', **rest)
      super
    end
  end
end
