# frozen_string_literal: true

module Blacklight
  # Overrides Blacklight's facet modal pagination to render the sort options as a
  # dropdown (matching the index view's sort/per-page dropdowns) instead of the
  # default A-Z / Numerical buttons. Prev/next paging is unchanged.
  class FacetFieldPaginationComponent < Blacklight::Component
    def initialize(facet_field:, button_classes: %w[btn btn-outline-secondary], show_sort: true)
      super()
      @facet_field = facet_field
      @button_classes = button_classes.join(' ')
      @show_sort = show_sort
    end

    attr_reader :show_sort

    def sort_facet_url(sort)
      @facet_field.paginator.params_for_resort_url(sort, @facet_field.search_state.to_h)
    end

    def current_sort
      @facet_field.paginator.sort
    end

    def param_name
      @facet_field.paginator.class.request_keys[:page]
    end

    def render?
      @facet_field.paginator
    end
  end
end
