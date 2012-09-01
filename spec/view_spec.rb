require_relative 'spec_helper'

describe TownCrier::View do
  let(:event) { Minitest::Mock.new }
  subject {TownCrier::View.new(event) }

  it "is initialized with an event" do
    event = "event"
    view = TownCrier::View.new(event)
    view.event.must_equal event
  end

  it "has a title of the 'event.key event'" do
    event.expect :key, "ns.account.create"
    subject.title.must_equal "ns.account.create event"
    event.verify
  end

  it "has a message that is the title plus the timestamp" do
    t = Time.now.to_i
    event.expect :timestamp, t
    event.expect :key, "ns.account.create"
    subject.message.must_match /ns.account.create event.+#{Time.now.to_s}/
    event.verify
  end
end
