# frozen_string_literal: true

require 'rails_helper'

# Renders the filtered facet values returned into the sidebar facet-search turbo
# frame: matching values as rows, already-selected values excluded, and a "No
# results found" message when empty.
RSpec.describe Index::FacetSearchResultComponent, type: :component do
  let(:facet_config) do
    Blacklight::Configuration::NullField.new(
      key: 'subjects_ssim',
      item_component: Blacklight::Facets::ItemComponent,
      item_presenter: Blacklight::FacetItemPresenter
    )
  end
  let(:paginator) { instance_double(Blacklight::FacetPaginator, items: items) }
  let(:facet_field) do
    instance_double(Blacklight::FacetFieldPresenter, paginator: paginator, facet_field: facet_config,
                                                     key: 'subjects_ssim', label: 'Subject')
  end

  before do
    # The paginator items double as their own presenters for this test.
    allow(facet_field).to receive(:item_presenter) { |item| item }
    render_inline(described_class.new(facet_field: facet_field, id: 'facet-search-subjects_ssim-results',
                                      classes: 'facet-search-results'))
  end

  context 'with matching values (one already selected)' do
    let(:items) do
      [
        instance_double(Blacklight::FacetItemPresenter, facet_config: facet_config, label: 'Applied', hits: 9,
                                                        href: '/catalog?f=applied', selected?: true),
        instance_double(Blacklight::FacetItemPresenter, facet_config: facet_config, label: 'Fishing', hits: 3,
                                                        href: '/catalog?f=fishing', selected?: false)
      ]
    end

    it 'lists only the unselected values' do
      expect(page).to have_css('ul#facet-search-subjects_ssim-results.facet-search-results')
      expect(page).to have_css('li', count: 1)
      expect(page).to have_link('Fishing', href: '/catalog?f=fishing')
    end
  end

  context 'with no matching values' do
    let(:items) { [] }

    it 'renders a "No results found" message' do
      expect(page).to have_css('div#facet-search-subjects_ssim-results.facet-search-results')
      expect(page).to have_text('No results found')
    end
  end
end
