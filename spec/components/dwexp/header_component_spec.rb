# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dwexp::HeaderComponent, type: :component do
  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.add_search_field('all_fields', label: 'All Fields')
      config.index.search_bar_component = Dwexp::SearchBarComponent
    end
  end

  before do
    allow(vc_test_controller).to receive_messages(
      blacklight_config: blacklight_config,
      search_action_url: '/catalog',
      params: ActionController::Parameters.new
    )
    render_inline(described_class.new(blacklight_config: blacklight_config))
  end

  it 'renders the identity bar' do
    expect(page).to have_link('Stanford University', href: 'https://www.stanford.edu')
  end

  it 'renders the search bar' do
    expect(page).to have_css('form.search-query-form')
  end
end
