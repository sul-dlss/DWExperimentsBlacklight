# frozen_string_literal: true

require 'rails_helper'

# The turbo-frame endpoint backing the sidebar facet-search box.
RSpec.describe 'Catalog facet results' do
  it 'returns a turbo frame of the facet values matching the query fragment' do
    get facet_results_catalog_path(id: 'subjects_ssim', query_fragment: 'phys')

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('<turbo-frame id="facet-search-subjects_ssim">')
    expect(response.body).to include('Physics')
  end

  it 'returns the frame when the query fragment is cleared (empty)' do
    get facet_results_catalog_path(id: 'subjects_ssim', query_fragment: '')

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('<turbo-frame id="facet-search-subjects_ssim">')
  end
end
