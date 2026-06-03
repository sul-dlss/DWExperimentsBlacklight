# frozen_string_literal: true

module Dwexp
  class ContributorTableComponent < ViewComponent::Base
    def initialize(field:, **_kwargs)
      super()
      @field = field
      @document = field.document
    end

    def contributors
      (creator_data + contributor_data).uniq do |contributor|
        [contributor['name'], contributor['name_identifiers']]
      end
    end

    private

    # Structured data for creators; by default they have no role, so we add "Creator"
    def creator_data
      @creator_data ||= JSON.parse(@document[:creators_struct_ss] || '[]').tap do |creators|
        creators.each { |creator| creator['role'] = 'Creator' }
      end
    end

    # Structured data for contributors
    def contributor_data
      @contributor_data ||= JSON.parse(@document[:contributors_struct_ss] || '[]')
    end
  end
end
