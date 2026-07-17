# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Show::ContributorModalComponent, type: :component do
  subject(:component) { described_class.new(contributors:, facet:, records:) }

  let(:contributors) { ['Anna Rasmussen'] }
  let(:records) { [] }
  let(:ror_org) { nil }
  let(:display_facet) do
    items = [Blacklight::Solr::Response::Facets::FacetItem.new(value: 'Anna Rasmussen', hits: 1234)]
    Blacklight::Solr::Response::Facets::FacetField.new('contributors_ssim', items)
  end
  let(:facet) { instance_double(Blacklight::FacetFieldPresenter, display_facet:, key: 'contributors_ssim') }

  before do
    allow(RorService).to receive(:get_by_id).and_return(ror_org)
    render_inline(component)
  end

  it 'titles the modal with the contributor name' do
    expect(page).to have_css('.modal-title', text: 'Anna Rasmussen')
  end

  context 'when the contributor has more than one dataset' do
    it 'links the title to the contributor faceted search, labeled with the delimited dataset count' do
      expect(page).to have_link('View 1,234 datasets',
                                href: %r{/catalog\?f%5Bcontributors_ssim%5D%5B%5D=Anna\+Rasmussen})
    end

    it 'marks the search link with a magnifying glass icon' do
      expect(page).to have_css('.modal-title a svg.bi-search')
    end
  end

  context 'when the contributor record has an ORCID and Stanford profile' do
    let(:records) do
      [{ 'name' => 'Anna Rasmussen',
         'name_identifiers' => [{ 'name_identifier' => '0000-0003-2837-8753',
                                  'name_identifier_scheme' => 'ORCID' },
                                { 'name_identifier' => '12345',
                                  'name_identifier_scheme' => 'CAP' }] }]
    end

    it 'links to the ORCID profile in the header, labeled "ORCID record"' do
      expect(page).to have_css('.modal-header a[href="https://orcid.org/0000-0003-2837-8753"]',
                               text: 'ORCID record')
    end

    it 'links to the Stanford profile in the header' do
      expect(page).to have_css('.modal-header a[href="https://profiles.stanford.edu/intranet/12345"]',
                               text: 'Stanford profile')
    end
  end

  context 'when the contributor name resolves to more than one record' do
    let(:records) do
      [{ 'name' => 'Anna Rasmussen',
         'name_identifiers' => [{ 'name_identifier' => '0000-0003-2837-8753',
                                  'name_identifier_scheme' => 'ORCID' }] },
       { 'name' => 'Anna Rasmussen',
         'name_identifiers' => [{ 'name_identifier' => '0000-0002-1111-2222',
                                  'name_identifier_scheme' => 'ORCID' }] }]
    end

    it 'omits the header ORCID and profile links rather than guess between the records' do
      expect(page).to have_no_css('.modal-header a[href*="orcid.org"]')
    end
  end

  context 'with affiliations for the contributor' do
    let(:records) do
      [{ 'name' => 'Anna Rasmussen',
         'affiliation' => [{ 'name' => 'Stanford University',
                             'affiliation_identifier' => 'https://ror.org/00f54p054',
                             'affiliation_identifier_scheme' => 'ROR',
                             'affiliation_department_name' => ['Department of Psychology'] }] }]
    end

    it 'renders an affiliations section listing the institution' do
      expect(page).to have_css('section h2', text: 'Affiliations')
      expect(page).to have_css('section', text: 'Stanford University')
    end

    it 'lists the affiliation departments' do
      expect(page).to have_css('section', text: 'Department of Psychology')
    end

    it 'links the affiliation to its ROR record' do
      expect(page).to have_link(href: 'https://ror.org/00f54p054')
    end

    context 'with ROR location data' do
      let(:ror_org) { instance_double(RorService::Org, country_name: 'United States') }

      it 'shows the affiliation location' do
        expect(page).to have_css('section', text: 'United States')
      end
    end
  end
end
