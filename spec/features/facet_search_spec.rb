# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sidebar facet search', :js do
  before do
    # Desktop width so the offcanvas-md facet panel renders inline (not hidden).
    page.current_window.resize_to(1400, 1000)
    visit search_catalog_path(q: '', search_field: 'all_fields')
    # The Subject facet overflows its limit, so it renders the search box; expand
    # it if it isn't already open.
    within('.blacklight-subjects_ssim') do
      find('.accordion-button').click unless page.has_css?('.facet-content.show', wait: 0)
    end
  end

  it 'filters facet values through the live search box' do
    within('.blacklight-subjects_ssim') do
      expect(page).to have_link('Browse all')
      fill_in 'facet-search-subjects_ssim-search', with: 'phys'
      expect(page).to have_css('.facet-search-results a', text: 'Physics')
    end
  end
end
