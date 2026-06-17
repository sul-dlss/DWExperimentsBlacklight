# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Show::ContributorTableComponent, type: :component do
  subject(:component) { described_class.new(document:) }

  let(:document) do
    SolrDocument.new(
      id: 'abc-123',
      creators_struct_ss: creators.to_json,
      contributors_struct_ss: contributors.to_json
    )
  end
  let(:creators) { [] }
  let(:contributors) { [] }

  # Affiliation country rendering reaches out to the ROR API; stub it out.
  before { allow(RorService).to receive(:get_by_id).and_return(nil) }

  context 'when there are no creators or contributors' do
    it 'renders nothing' do
      render_inline(component)
      expect(page).to have_no_css('#contributors')
    end
  end

  context 'when creators and contributors are present' do
    let(:creators) do
      [{ 'name' => 'Alexandra Trelle',
         'name_identifiers' => [{ 'name_identifier' => '0000-0003-2837-8753',
                                  'name_identifier_scheme' => 'ORCID' }],
         'affiliation' => [{ 'name' => 'Stanford University',
                             'affiliation_identifier' => 'https://ror.org/00f54p054',
                             'affiliation_identifier_scheme' => 'ROR' }] }]
    end
    let(:contributors) { [{ 'name' => 'Jane Doe', 'name_identifiers' => [] }] }

    before { render_inline(component) }

    it 'renders the section heading' do
      expect(page).to have_css('#contributors h2', text: 'Contributors')
    end

    it 'renders a row per contributor' do
      expect(page).to have_css('tbody tr', count: 2)
    end

    it 'links each contributor name to its facet search' do
      expect(page).to have_link('Alexandra Trelle',
                                href: %r{/catalog\?f%5Bcontributors_ssim%5D%5B%5D=Alexandra\+Trelle})
      expect(page).to have_link('Jane Doe',
                                href: %r{/catalog\?f%5Bcontributors_ssim%5D%5B%5D=Jane\+Doe})
    end

    it 'renders an ORCID link for contributors with an ORCID identifier' do
      expect(page).to have_link(href: 'https://orcid.org/0000-0003-2837-8753')
    end

    it 'renders a collaborators modal link for each contributor' do
      expect(page).to have_css('a[data-blacklight-modal="trigger"]', count: 2)
    end
  end

  context 'when a creator and a contributor share a name and identifiers' do
    let(:creators) { [{ 'name' => 'Sam Smith', 'name_identifiers' => [] }] }
    let(:contributors) { [{ 'name' => 'Sam Smith', 'name_identifiers' => [] }] }

    it 'de-duplicates them into a single row' do
      render_inline(component)
      expect(page).to have_css('tbody tr', count: 1)
    end
  end
end
