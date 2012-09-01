require_relative "../spec_helper"

describe TownCrier::MultiChannel do
  it "initializes with an array of channels" do
    subject = TownCrier::MultiChannel.new([:one, :two])
    subject.channels.must_equal [:one, :two]
  end

  it "publishes to each channel in order" do
    channel1 = MiniTest::Mock.new
    channel2 = MiniTest::Mock.new
    subject = TownCrier::MultiChannel.new([channel1, channel2])
    event = "stub_event"
    channel1.expect :publish, nil, [event]
    channel2.expect :publish, nil, [event]
    subject.publish(event)
    channel1.verify
    channel2.verify
  end
end
