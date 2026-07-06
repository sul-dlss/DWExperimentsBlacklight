# frozen_string_literal: true

module Index
  class RangeFormComponent < BlacklightRangeLimit::RangeFormComponent
    # Whether a range filter is currently applied to the search.
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
