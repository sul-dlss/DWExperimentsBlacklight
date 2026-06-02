# frozen_string_literal: true

module ApplicationHelper
  def link_to_url(doc)
    link_to doc['url_ss'], doc['url_ss']
  end
end
