require_relative '../spec_helper'

class MockRushoverClient
  attr_accessor :published

  def initialize
    @published = []
  end

  def notify(user_key, message, options = {})
    @published << {
      :user_key => user_key,
      :message  => message,
      :options  => options
    }
  end
end

describe TownCrier::PushoverChannel do
  let(:lookup) { TownCrier::UserLookup.new }
  let(:event) { TownCrier::Event.new("type" => "test", "action" => "create") }
  subject { TownCrier::PushoverChannel.new(lookup, :token => "test_token") }

  it "has a key of 'pushover'" do
    subject.key.must_equal "pushover"
  end

  it "sets the lookup contact_key" do
    lookup = Minitest::Mock.new
    lookup.expect :contact_key=, nil, [:pushover_key]
    subject = TownCrier::PushoverChannel.new(lookup, {})
    lookup.verify
  end

  describe "publishing to recipients" do
    let(:joe) { TownCrier::User.create(:name => "joe", :email => "joe@example.com", :pushover_key => "push_joe") }
    let(:jane) { TownCrier::User.create(:name => "jane", :email => "jane@example.com", :pushover_key => "push_jane") }
    let(:client) { MockRushoverClient.new }

    before do
      subject
      joe.add_event_binding("default.test.create.pushover")
      jane.add_event_binding("default.test.create.pushover")
    end

    it "notifies matching recipients" do
      Rushover::Client.stub :new, client do
        subject.publish(event)
      end

      client.published.collect {|p| p[:user_key] }.must_equal ["push_joe", "push_jane"]
    end

    it "skips recipients that don't have a pushover key set" do
      jane.pushover_key = ""
      jane.save
      Rushover::Client.stub :new, client do
        subject.publish(event)
      end

      client.published.collect {|p| p[:user_key] }.must_equal ["push_joe"]
    end
  end
end
