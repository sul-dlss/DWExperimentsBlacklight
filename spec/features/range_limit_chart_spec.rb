# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Range limit distribution chart', :js do
  before do
    # Desktop width so the offcanvas-md facet panel renders inline (not hidden).
    page.current_window.resize_to(1400, 1000)
    visit search_catalog_path(q: '', search_field: 'all_fields')
  end

  it 'renders a single chart even if turbo frame loads' do # rubocop:disable RSpec/ExampleLength
    # Expand the Publication Year range facet so its distribution chart renders.
    within('.blacklight-publication_year_isi') do
      find('.accordion-button').click unless page.has_css?('.facet-content.show', wait: 0)
      expect(page).to have_css('canvas.blacklight-range-limit-chart', count: 1)
    end

    # Type into the Subject facet search box, which loads results into a turbo
    # frame (firing turbo:frame-load) without selecting anything.
    within('.blacklight-subjects_ssim') do
      find('.accordion-button').click unless page.has_css?('.facet-content.show', wait: 0)
      fill_in 'facet-search-subjects_ssim-search', with: 'phys'
      expect(page).to have_css('.facet-search-results a', text: 'Physics')
    end

    # The year chart must not have been re-rendered / duplicated.
    within('.blacklight-publication_year_isi') do
      expect(page).to have_css('canvas.blacklight-range-limit-chart', count: 1)
    end
  end
end
