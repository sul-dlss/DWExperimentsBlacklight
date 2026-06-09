# frozen_string_literal: true

module Documents
  class MetadataComponent < ViewComponent::Base
    def initialize(document:)
      @document = document
      super()
    end

    def description_preview
      return if @document.description.blank?

      helpers.render_rich_text_preview(value: Array(@document.description))
    end
  end
end
