class Openalex
    require 'net/http'
  
    # Initialize independent of the specific URI to be used
    def initialize
      # This is the base for the REST API
      @base_datasets_url = "https://api.openalex.org/works/"
      @base_prefix = "https://api.openalex.org/"
    end
  
    # This is not necessarily a single "file" but dataset as defined by the service
    def retrieve_metadata(source_identifier_ssi)
      # Which identifier do we use to retrieve the data    
      prefix = 'https://openalex.org/'
      json_response(metadata_url(source_identifier_ssi[prefix.length, source_identifier_ssi.length]))
    end

    # Retrieve metadata given a particular list of identifiers
    # ids = array of ids
    def retrieve_metadata_by_ids(ids:, type:)
      # To pass multiple ids to OpenAlex, we need to pass id1|id2|id3
      query_ids = ids.join('|')
      # Default to DOI as last case
      case type
      when 'ISSN'
        id_path = "#{@base_prefix}sources?filter=issn:#{query_ids}&select=id,ids,issn,display_name,homepage_url"
      when 'PMID'
        id_path = "#{@base_prefix}works?filter=ids.pmid:#{query_ids}&select=id,ids,title,doi,publication_year,primary_location,type,authorships"
      when 'OpenAlex'
        id_path = "#{@base_prefix}works?filter=openalex:#{query_ids}&select=id,ids,title,doi,publication_year,primary_location,type,authorships"
      else
        dois = ids.map { |id| "https://doi.org/#{id}" }.join('|')
        id_path = "#{@base_prefix}works?filter=doi:#{dois}&select=id,ids,title,doi,publication_year,primary_location,type,authorships"
      end
      json_response("#{id_path}&per-page=200")
    end

    def json_response(url)
      resp = Net::HTTP.get_response(URI.parse(url))
      data = resp.body
      JSON.parse(data)
    rescue JSON::ParserError, Net::HTTPBadResponse, Timeout::Error => e
      { error: "Failed OpaAlex request: #{e.message}" }
    end
  
    def metadata_url(source_identifier_ssi)
      @base_datasets_url + source_identifier_ssi
    end
  end