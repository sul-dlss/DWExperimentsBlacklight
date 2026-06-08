# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dwexp::SearchButtonComponent, type: :component do
  subject(:component) { described_class.new(id: 'search', text: 'Search') }

  before { render_inline(component) }

  it 'renders a submit button' do
    expect(page).to have_button(type: 'submit')
  end

  it 'renders the button text' do
    expect(page).to have_css('span.d-none.d-sm-flex', text: 'Search')
  end
end
