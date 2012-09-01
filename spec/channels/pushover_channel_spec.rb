require_relative '../spec_helper'

describe TownCrier::PushoverChannel do
  let(:lookup) { MiniTest::Mock.new }
  let(:client) { MiniTest::Mock.new }
  subject { TownCrier::PushoverChannel.new(lookup, {}) }

  it "has a key of 'pushover'" do
    subject.key.must_equal "pushover"
  end
end
