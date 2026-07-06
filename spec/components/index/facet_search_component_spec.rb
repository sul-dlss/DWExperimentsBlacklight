# frozen_string_literal: true

require 'rails_helper'

# The sidebar facet renderer that adds the SearchWorks-style facet search box
# (and "Browse all" link) below the values, only when the facet overflows its
# display limit (i.e. has a modal_path).
RSpec.describe Index::FacetSearchComponent, type: :component do
  let(:facet_config) do
    Blacklight::Configuration::NullField.new(
      key: 'subjects_ssim',
      item_component: Blacklight::Facets::ItemComponent,
      item_presenter: Blacklight::FacetItemPresenter
    )
  end
  let(:item) do
    instance_double(Blacklight::FacetItemPresenter, facet_config: facet_config, label: 'Fishing', hits: 3,
                                                    href: '/catalog?f=fishing', selected?: false)
  end
  let(:paginator) { instance_double(Blacklight::FacetPaginator, items: [item]) }
  let(:facet_field) do
    instance_double(
      Blacklight::FacetFieldPresenter,
      paginator: paginator,
      facet_field: facet_config,
      key: 'subjects_ssim',
      label: 'Subject',
      active?: false,
      collapsed?: false,
      values: [],
      modal_path: '/catalog/facet/subjects_ssim'
    )
  end

  before do
    allow(facet_field).to receive(:item_presenter) { |i| i }
    allow(vc_test_controller.view_context).to receive(:search_state)
      .and_return(instance_double(Blacklight::SearchState, to_h: {}))

    with_request_url '/catalog?q=' do
      render_inline(described_class.new(facet_field: facet_field))
    end
  end

  it 'renders the facet values' do
    expect(page).to have_css('ul.facet-values')
    expect(page).to have_link('Fishing', href: '/catalog?f=fishing')
  end

  it 'renders the "Browse all" link' do
    expect(page).to have_css('.more_facets a')
  end

  it 'renders the facet search combobox wired to the facet-search controller' do
    expect(page).to have_css('[data-controller="facet-search"]')
    expect(page).to have_css('input[role="combobox"][placeholder="Search subject"]')
  end

  it 'renders the turbo frame that receives the results' do
    expect(page).to have_css('turbo-frame#facet-search-subjects_ssim')
  end
end
