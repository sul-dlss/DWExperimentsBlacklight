# frozen_string_literal: true

require 'rails_helper'

# Our override renders the facet-modal sort control as a dropdown (matching the
# index view's sort/per-page dropdowns) instead of A-Z / Numerical buttons.
RSpec.describe Index::FacetPaginationComponent, type: :component do
  let(:sort) { 'index' }
  # 5 values with a page limit of 2 gives a "next" page (and no "previous").
  let(:paginator) { Blacklight::Solr::FacetPaginator.new([1, 2, 3, 4, 5], limit: 2, offset: 0, sort: sort) }
  let(:search_state) { instance_double(Blacklight::SearchState, to_h: {}) }
  let(:facet_field) do
    instance_double(Blacklight::FacetFieldPresenter, paginator: paginator, search_state: search_state, label: 'Subject')
  end

  def render_component
    with_request_url '/catalog/facet/subjects_ssim' do
      render_inline(described_class.new(facet_field: facet_field))
    end
  end

  context 'when sorted A-Z (index)' do
    let(:sort) { 'index' }

    before { render_component }

    it 'labels the dropdown button with the current sort' do
      expect(page).to have_button('Sort by A-Z', class: %w[btn btn-outline-primary dropdown-toggle])
    end

    it 'offers both sort options, with the current one active' do
      expect(page).to have_css('.dropdown-menu a.dropdown-item', text: 'A-Z')
      expect(page).to have_css('.dropdown-menu a.dropdown-item', text: 'Number of matches')
      expect(page).to have_css('a.dropdown-item.active', text: 'A-Z')
    end

    it 'renders the prev/next paging links' do
      expect(page).to have_css('.prev_next_links')
    end
  end

  context 'when sorted by count' do
    let(:sort) { 'count' }

    before { render_component }

    it 'labels the button with the lowercase selection and marks the option active' do
      expect(page).to have_button('Sort by number of matches', class: 'dropdown-toggle')
      expect(page).to have_css('a.dropdown-item.active', text: 'Number of matches')
    end
  end
end
