require "sinatra/base"
require 'rack/parser'

module TownCrier
  class Server < Sinatra::Base
    use Rack::Parser

    dir = File.dirname(File.expand_path(__FILE__))
    set :views,  "#{dir}/server/views"

    set :queue, TownCrier::Queue

    post "/api/v1/events" do
      content_type :json
      settings.queue << params

      #placeholder for now to pass linting, etc
      "ok"
    end
  end
end
