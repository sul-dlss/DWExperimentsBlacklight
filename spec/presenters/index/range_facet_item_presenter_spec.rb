# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Index::RangeFacetItemPresenter do
  subject(:presenter) do
    described_class.new(facet_item, facet_config, view_context, 'temporal_isim', search_state)
  end

  let(:facet_config) { CatalogController.blacklight_config.facet_fields['temporal_isim'] }
  let(:view_context) { instance_double(ActionView::Base) }
  let(:search_state) { instance_double(Blacklight::SearchState) }

  context 'when the item represents documents with no value' do
    let(:facet_item) do
      Blacklight::Solr::Response::Facets::FacetItem.new(
        value: Blacklight::SearchState::FilterField::MISSING, hits: 100
      )
    end

    it 'labels it "Year not specified" instead of the default "[Missing]"' do
      expect(presenter.label).to eq('Year not specified')
    end
  end
end
