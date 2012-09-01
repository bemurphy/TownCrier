require_relative 'spec_helper'

describe TownCrier::EventBinding do
  def binding_params
    {
      :namespace => "ns",
      :type      => "account",
      :action    => "create",
      :channel   => "email"
    }
  end

  subject { TownCrier::EventBinding.new(binding_params) }

  it "has a namespace" do
    subject.namespace.must_equal "ns"
  end

  it "has a type" do
    subject.type.must_equal "account"
  end

  it "has a action" do
    subject.action.must_equal "create"
  end

  it "has a channel" do
    subject.channel.must_equal "email"
  end

  it "can initialize from a '.' delimited string of 4 parts" do
    subject = TownCrier::EventBinding.from_string("foo.user.destroy.sms")
    subject.namespace.must_equal "foo"
    subject.type.must_equal "user"
    subject.action.must_equal "destroy"
    subject.channel.must_equal "sms"
  end

  it "converts to_s as a '.' delimited string" do
    subject.to_s.must_equal "ns.account.create.email"
  end

  it "can be == compared to another event binding" do
    other = TownCrier::EventBinding.new(binding_params)
    assert subject == other
    other.namespace = "other"
    refute subject == other
  end

  it "can be == compared to a string that looks like an event binding" do
    assert subject == "ns.account.create.email"
    refute subject == "ns.account.create.sms"
    refute subject == "foo.account.create.email"
  end
end
