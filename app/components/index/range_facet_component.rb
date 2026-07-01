# frozen_string_literal: true

module Index
  # Local override of the blacklight_range_limit range facet. The only change
  # from upstream is display order: the From/To/Apply form is rendered above the
  # distribution chart instead of below it.
  class RangeFacetComponent < BlacklightRangeLimit::RangeFacetComponent
  end
end
