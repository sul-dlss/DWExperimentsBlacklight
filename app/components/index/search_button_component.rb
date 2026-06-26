# frozen_string_literal: true

module Index
  class SearchButtonComponent < Blacklight::SearchButtonComponent
    def call
      tag.div(class: 'search-btn-wrapper rounded-end d-flex') do
        tag.button(class: 'btn btn-primary search-btn', type: 'submit', id: @id) do
          # Text visible only on sm and larger screens
          tag.span(t('blacklight.search.search_bar_button'), class: 'd-none d-sm-flex')
        end
      end
    end
  end
end
