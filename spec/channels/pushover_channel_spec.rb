require_relative '../spec_helper'

describe TownCrier::PushoverChannel do
  let(:lookup) { MiniTest::Mock.new }
  let(:client) { MiniTest::Mock.new }
  subject { TownCrier::PushoverChannel.new(lookup, {}) }

  before do
    lookup.expect :infect_an_attribute, nil, [:pushover_key]
  end

  it "has a key of 'pushover'" do
    subject.key.must_equal "pushover"
  end

  it "infects via the lookup with a pushover_key attribute" do
    subject
    lookup.verify
  end
end
