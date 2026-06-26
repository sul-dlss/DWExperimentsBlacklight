# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdentityBarComponent, type: :component do
  it 'renders the Stanford University link' do
    render_inline(described_class.new)
    expect(page).to have_link('Stanford University', href: 'https://www.stanford.edu')
  end
end
