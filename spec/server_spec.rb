require_relative "spec_helper"

class MockQueue
  attr_accessor :datas

  def initialize
    @datas = []
  end

  def <<(data)
    @datas << data
  end
end

describe TownCrier::Server do
  let(:queue) { MockQueue.new }

  before do
    app.set :queue, queue
  end

  it "receives events at /api/v1/events" do
    post '/api/v1/events', {}
    last_response.status.wont_equal 404
  end

  it "pushes a valid event into the queue" do
    event_hash = { "type" => "account", "action" => "create" }
    post "/api/v1/events", event_hash.to_json, { "CONTENT_TYPE" => "application/json" }
    queue.datas.first.type.must_equal "account"
    queue.datas.first.action.must_equal "create"
    assert last_response.ok?
  end

  it "returns status 400 if the event data is not valid" do
    event_hash = { "type" => "account" }
    post "/api/v1/events", event_hash.to_json, { "CONTENT_TYPE" => "application/json" }
    last_response.status.must_equal 400
  end
end
