# frozen_string_literal: true

require 'rails_helper'

# Our override of Blacklight's facet-modal filter box: screen-reader-only label,
# inset search icon, and a "Search <facet>" placeholder.
RSpec.describe Blacklight::Facets::SuggestComponent, type: :component do
  let(:facet) { Blacklight::Configuration::FacetField.new(key: 'subjects_ssim') }
  let(:presenter) { Blacklight::FacetFieldPresenter.new(facet, nil, vc_test_controller.view_context, nil) }
  let(:component) { described_class.new(presenter: presenter) }

  before { allow(presenter).to receive(:label).and_return('Subject') }

  def rendered
    with_request_url('/catalog/facet/subjects_ssim') { render_inline(component) }
  end

  it 'renders the filter input with a "Search <facet>" placeholder' do
    expect(rendered.css('input.facet-suggest[placeholder="Search subject"]').count).to eq 1
  end

  it 'associates a screen-reader-only label with the input' do
    label = rendered.css('label.visually-hidden').first
    expect(label.text.strip).to eq 'Search subject'
    expect(label['for']).to eq 'facet_suggest_subjects_ssim'
  end

  it 'renders the inset search icon' do
    expect(rendered.css('.facet-suggest-group .facet-suggest-icon svg').count).to eq 1
  end
end
