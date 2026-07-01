# frozen_string_literal: true

module Index
  # Local override of the blacklight_range_limit range form. Behavior is
  # inherited from upstream; the changes are in the template: the
  # From/To inputs and the (solid blue) Apply button are fixed width and left
  # aligned, with a Reset link on the right that only appears when a range is
  # currently applied and clears it.
  class RangeFormComponent < BlacklightRangeLimit::RangeFormComponent
    # Whether a temporal range filter is currently applied to the search.
    def range_applied?
      @facet_field.selected_range.is_a?(Range)
    end

    # URL for the current search with this range filter removed.
    def reset_path
      cleared_state = @facet_field.search_state.filter(@facet_field.key).remove(@facet_field.selected_range_facet_item)
      search_action_path(cleared_state)
    end
  end
end
