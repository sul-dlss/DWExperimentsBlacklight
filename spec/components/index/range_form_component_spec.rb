# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Index::RangeFormComponent, type: :component do
  subject(:component) { described_class.new(facet_field:) }

  let(:facet_field) do
    instance_double(
      BlacklightRangeLimit::FacetFieldPresenter,
      key: 'temporal_isim',
      selected_range:,
      selected_range_facet_item: Blacklight::Solr::Response::Facets::FacetItem.new(value: 2000..2010),
      search_state:
    )
  end
  let(:search_state) do
    Blacklight::SearchState.new(
      ActionController::Parameters.new(range: { 'temporal_isim' => { begin: '2000', end: '2010' } }),
      CatalogController.blacklight_config
    )
  end

  describe '#range_applied?' do
    context 'when a range is selected' do
      let(:selected_range) { 2000..2010 }

      it { expect(component.range_applied?).to be true }
    end

    context 'when no range is selected' do
      let(:selected_range) { nil }

      it { expect(component.range_applied?).to be false }
    end
  end

  describe '#reset_path' do
    let(:selected_range) { 2000..2010 }

    it 'points at the search with this range filter removed' do
      allow(component).to receive(:search_action_path) { |state| state } # rubocop:disable RSpec/SubjectStub

      expect(component.reset_path.to_h.dig(:range, 'temporal_isim')).to be_nil
    end
  end
end
