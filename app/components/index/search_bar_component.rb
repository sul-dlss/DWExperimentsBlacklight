# frozen_string_literal: true

module Index
  class SearchBarComponent < Blacklight::SearchBarComponent
    def initialize(**kwargs)
      super(**kwargs.merge(classes: %w[search-query-form col-md-12 col-lg-8]))
    end
  end
end
