# frozen_string_literal: true

module Show
  # Toolbar of record-level tools (copy link, print) shown at the top of the
  # show page. Mirrors the SearchWorks record toolbar design.
  class ToolbarComponent < ViewComponent::Base
    def initialize(document:)
      @document = document
      super()
    end

    attr_reader :document

    # Absolute, shareable URL for the current record.
    def copy_url
      helpers.solr_document_url(document)
    end
  end
end
