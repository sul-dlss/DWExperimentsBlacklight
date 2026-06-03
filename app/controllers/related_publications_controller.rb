# frozen_string_literal: true

# Controller that handles request to retrieve information about related publications
class RelatedPublicationsController < ApplicationController
  # Get info from Open Alex API regarding particular DOIs or identifiers
  # The parameter accepts a string of ids as well
  def openalex_info
    ids = params[:ids]
    type = params[:type] || 'doi'
    response = {}

    if ids.present?
      oa = Openalex.new
      response = oa.retrieve_metadata_by_ids(ids:, type:)
    end
    render json: response
  end
end
