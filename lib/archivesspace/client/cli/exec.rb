# frozen_string_literal: true

module ArchivesSpace
  class Client
    module CLI
      # ArchivesSpace::Client::CLI::Exec executes an API request
      class Exec < Dry::CLI::Command
        desc 'Execute an API request'

        argument :type, required: true, values: %i[get post put delete], desc: 'API request type'
        argument :path, required: true, desc: 'API request path'

        option   :rid, type: :integer, default: nil, desc: 'Repository id'
        option   :payload, type: :string, default: '{}', desc: 'Data payload (json)'
        option   :params, type: :string, default: '{}', desc: 'Params (json)'

        example [
          'exec get --rid 2 "resources/1"',
          'exec get users --params \'{"query": {"page": 1}}\''
        ]

        def call(type:, path:, rid: nil, payload: '{}', params: '{}', **)
          client = ArchivesSpace::Client::CLI.client
          client.repository(rid) if rid
          type    = type.to_sym
          payload = JSON.parse(payload, symbolize_names: true)
          params  = JSON.parse(params, symbolize_names: true)

          response = case type
                     when :get
                       client.get(path, params)
                     when :post
                       client.post(path, payload, params)
                     when :put
                       client.put(path, payload, params)
                     when :delete
                       client.delete(path)
                     end
          puts JSON.generate(response.parsed)
        end
      end
    end
  end
end
