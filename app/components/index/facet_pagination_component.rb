# frozen_string_literal: true

module Index
  # Renders the facet "Browse all" modal pagination with the sort options as a
  # dropdown (matching the index view's sort/per-page dropdowns) instead of
  # Blacklight's default A-Z / Numerical buttons. Prev/next paging is inherited
  # unchanged. The stock facet.html.erb renders this in both the top and bottom
  # rows; the bottom sort dropdown is hidden via CSS (.facet-pagination.bottom).
  class FacetPaginationComponent < Blacklight::FacetFieldPaginationComponent
    def current_sort
      @facet_field.paginator.sort
    end
  end
end
