require_relative 'spec_helper'

describe TownCrier::Event do
  def event_hash(overrides = {})
    {
      "namespace" => "foobar",
      "type"      => "account",
      "action"    => "create",
      "timestamp" => "123123",
      "meta"      => {
        "id"   => 42,
        "plan" => "gold"
      }
    }.merge(overrides)
  end

  subject { TownCrier::Event.new(event_hash) }

  it "fetches namespace from the initialization data" do
    subject.namespace.must_equal "foobar"
  end

  it "has a default namespace of 'default'" do
    subject = TownCrier::Event.new({})
    subject.namespace.must_equal "default"
  end

  it "fetches the type from the data" do
    subject.type.must_equal "account"
  end

  it "fetches the action from the data" do
    subject.action.must_equal "create"
  end

  it "fetches timestamp from the data" do
    subject.timestamp.must_equal "123123"
  end

  it "defaults the timestamp to Time.now if one is not provided" do
    subject.event_hash["timestamp"] = nil
    subject.timestamp.must_be_close_to(Time.now.to_i, 1)
  end

  it "can represent its key as namespace.type.action" do
    subject.key.must_equal "foobar.account.create"
  end

  it "sets an empty meta hash if not provided" do
    subject = TownCrier::Event.new({})
    assert subject.meta == {}
  end

  it "responds to dynamic meta_ methods" do
    subject.must_respond_to :meta_id
    subject.must_respond_to :meta_plan
  end

  it "dynamically replies to meta_ methods by checking the event meta subhash" do
    subject.meta_id.must_equal 42
    subject.meta_plan.must_equal "gold"
    subject.meta_missing.must_equal nil
  end

  it "can be initialized from json" do
    json = event_hash.to_json
    subject = TownCrier::Event.from_json(json)
    subject.event_hash.must_equal event_hash
  end

  it "converts to json using the event_hash" do
    json = event_hash.to_json
    subject = TownCrier::Event.new(event_hash)
    subject.to_json.must_equal json
  end

  it "is valid as long as it has a type and action" do
    subject = TownCrier::Event.new({})
    refute subject.valid?
    subject.event_hash["type"] = "account"
    refute subject.valid?
    subject.event_hash["action"] = "create"
    assert subject.valid?
  end

  it "is == to another event with the same hash" do
    other = TownCrier::Event.new(event_hash)
    assert subject == other
    other.event_hash["type"] = "other"
    refute subject == other
  end
end
