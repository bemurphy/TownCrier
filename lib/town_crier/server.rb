require "sinatra/base"
require 'rack/parser'
require 'town_crier/queue'

module TownCrier
  class Server < Sinatra::Base
    use Rack::Parser

    dir = File.dirname(File.expand_path(__FILE__))
    set :views,  "#{dir}/server/views"

    set :queue, TownCrier::Queue

    post "/api/v1/events" do
      content_type :json

      event = TownCrier::Event.new(params)
      if event.valid?
        settings.queue << event
        #placeholder for now to pass linting, etc
        "ok"
      else
        halt 400
      end
    end
  end
end
