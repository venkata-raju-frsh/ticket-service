module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      indexes :id, type: 'long'
      indexes :title, type: 'text'
      indexes :description, type: 'text'
    end

    def self.search(search_query)
       params = {
        query: {
            query_string: {query: search_query},
        }
      }

      self.__elasticsearch__.search(params).records.to_a
    end
  end
end