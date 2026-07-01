# frozen_string_literal: true

module Index
  # Range facet item presenter that relabels the "no value" (missing) item as
  # "Year not specified" instead of Blacklight's default "[Missing]". Scoped to
  # the temporal range facet via its item_presenter config, so other facets keep
  # the default label.
  class RangeFacetItemPresenter < BlacklightRangeLimit::FacetItemPresenter
    def label
      return I18n.t('blacklight.range_limit.missing') if value == Blacklight::SearchState::FilterField::MISSING

      super
    end
  end
end
