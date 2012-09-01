require_relative 'spec_helper'

describe TownCrier::Channel do
  let(:lookup) { MiniTest::Mock.new }
  subject { TownCrier::Channel.new(lookup, {}) }

  it "is initialized with a lookup instance and options" do
    lookup = "lookup"
    options = { :foo => :bar }
    subject = TownCrier::Channel.new(lookup, options)
    subject.lookup.must_equal lookup
    subject.options.must_equal options
  end

  it "finds recipients interested in an event using the lookup" do
    user1 = "user1"
    user2 = "user2"
    event = TownCrier::Event.new("type" => "account", "action" => "create")
    event_binding = TownCrier::EventBinding.from_string("default.account.create.channel")
    lookup.expect(:recipients, [user1, user2], [event_binding])

    recipients = subject.recipients(event)
    recipients.must_include user1
    recipients.must_include user2

    lookup.verify
  end

  it "finds a view using the view resolver" do
    class DefaultAccountCreateChannelView
      def initialize(*args); end
    end

    event = TownCrier::Event.new("type" => "account", "action" => "create")
    subject.view(event).must_be_instance_of(DefaultAccountCreateChannelView)
    Object.send(:remove_const, "DefaultAccountCreateChannelView")
  end
end
