# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Analytics' do
  it 'includes the analytics meta tag' do
    visit '/'
    expect(page).to have_css('meta[name="analytics_debug"]', visible: :hidden)
  end
end
