# frozen_string_literal: true

module Show
  # Renders the "Contributors" section of the show page: a two-column table
  # pairing each creator or contributor with their affiliation(s).
  class ContributorsComponent < ViewComponent::Base
    include AffiliationPresentation

    # Solr field backing the contributors facet, used for the search links.
    FACET_FIELD = 'contributors_ssim'

    # Number of contributors shown before the table collapses behind a toggle.
    VISIBLE_COUNT = 6

    def initialize(document:)
      @document = document
      super()
    end

    attr_reader :document

    def render?
      contributors.present?
    end

    # Creators and contributors, de-duplicated by name and identifiers.
    def contributors
      @contributors ||= document.contributors
    end

    # Render a contributor's affiliation(s) for the table's second column.
    def render_affiliations(contributor)
      affiliations = Array(contributor['affiliation'])
      return if affiliations.blank?

      safe_join(affiliations.map { |affiliation| render_affiliation(affiliation) })
    end

    # Render a single affiliation: its name and country, if present.
    def render_affiliation(affiliation)
      parts = [affiliation['name']]
      if (country = affiliation_country(affiliation))
        parts << tag.span(country, class: 'text-nowrap ms-2')
      end
      tag.div(safe_join(parts.compact))
    end

    # Render a contributor's name as a link that opens its detail modal.
    def render_name(contributor)
      link_to(contributor['name'],
              contributor_catalog_path(id: document.id, f: { FACET_FIELD => [contributor['name']] }),
              data: { blacklight_modal: 'trigger', turbo: false })
    end
  end
end
