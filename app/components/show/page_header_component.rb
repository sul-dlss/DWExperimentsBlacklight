# frozen_string_literal: true

module Show
  # Page header for the record (show) page: the search results link, the
  # paging controls, and the record toolbar.
  class PageHeaderComponent < Blacklight::Document::PageHeaderComponent
    # The toolbar is available on every record, regardless of
    # whether the visitor arrived from a search.
    def render?
      true
    end

    # The "Search results" link and paging controls are only meaningful when the
    # record was reached from a search.
    def search_context?
      search_context.present? || search_session.present?
    end
  end
end
