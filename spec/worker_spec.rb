require_relative 'spec_helper'

describe TownCrier::Worker do
  after { TownCrier.active_channel = nil }
  let(:channel) { Minitest::Mock.new }
  let(:event) { TownCrier::Event.new("type" => "test", "action" => "create") }

  if ENV["SLOW_TESTS"]
    it "publishes events from the queue to the active_channel" do
      TownCrier.active_channel = channel
      channel.expect :publish, nil, [event]
      TownCrier::Queue << event

      Thread.new do
        sleep 0.01
        Ost.stop
      end

      TownCrier::Worker.run
      channel.verify
    end
  end
end
