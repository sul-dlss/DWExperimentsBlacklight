# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Show::ToolbarComponent, type: :component do
  subject(:component) { described_class.new(document:) }

  let(:document) { SolrDocument.new(id: 'abc-123') }

  before { render_inline(component) }

  it 'renders a labeled toolbar' do
    expect(page).to have_css('nav.record-toolbar[aria-label="Tools"]')
  end

  it 'renders a copy link button wired to the copy-link controller' do
    expect(page).to have_css(
      'button[data-controller="copy-link"][data-action="click->copy-link#copyLink"]',
      text: 'Copy link'
    )
  end

  it 'points the copy link button at the absolute record URL' do
    button = page.find('button[data-controller="copy-link"]')
    expect(button['data-copy-link-url-value']).to end_with('/catalog/abc-123')
  end

  it 'passes the localized confirmation message to the copy-link controller' do
    button = page.find('button[data-controller="copy-link"]')
    expect(button['data-copy-link-message-value']).to eq('Link copied to clipboard')
  end

  it 'passes the localized failure message to the copy-link controller' do
    button = page.find('button[data-controller="copy-link"]')
    expect(button['data-copy-link-error-value']).to eq('Unable to copy link')
  end

  it 'renders a print button that triggers the browser print dialog' do
    expect(page).to have_css('button[onclick*="window.print"]', text: 'Print')
  end
end
