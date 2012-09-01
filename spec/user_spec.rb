require_relative 'spec_helper'

describe TownCrier::User do
  subject { TownCrier::User.new }

  it "requires a name" do
    subject.name = nil
    subject.valid?
    subject.errors.keys.must_include :name
  end

  it "requires an email address" do
    subject.email = nil
    subject.valid?
    subject.errors.keys.must_include :email
  end

  it "checks the format of the email address" do
    subject.email = "joe@example.com"
    subject.valid?
    subject.errors.keys.wont_include :email

    subject.email = "joe@example"
    subject.valid?
    subject.errors.keys.must_include :email
  end
end

describe TownCrier::User, "event bindings" do
  let(:event_binding) {
    TownCrier::EventBinding.new(:namespace => "ns", :type => "account", :action => "create", :channel => "email")
  }
  subject { TownCrier::User.create(:name => "Joe", :email => "joe@example.com") }

  it "allows binding to an event by adding the binding string in a set" do
    subject.add_event_binding(event_binding)
    subject.event_bindings.must_include "ns.account.create.email"
  end

  it "allows removing a binding" do
    subject.add_event_binding(event_binding)
    subject.remove_event_binding(event_binding)
    subject.event_bindings.must_equal []
  end

  it "can check if a a user has an event binding" do
    refute subject.bound_to?(event_binding)
    subject.add_event_binding(event_binding)
    assert subject.bound_to?(event_binding)
  end

  it "allow finding users with a matching event binding" do
    jane = TownCrier::User.create(:name => "Jane", :email => "jane@example.com")
    subject.add_event_binding(event_binding)
    TownCrier::User.with_event_binding(event_binding).must_include subject
    TownCrier::User.with_event_binding(event_binding).wont_include jane

    jane.add_event_binding(event_binding)
    TownCrier::User.with_event_binding(event_binding).must_include subject
    TownCrier::User.with_event_binding(event_binding).must_include jane
  end
end

describe TownCrier::User, "infecting with attributes" do
  subject { TownCrier::User }

  it "declares an attribute for the passed attribute" do
    subject.infect_an_attribute(:fizzbuzz_key)
    subject.new.methods.must_include :fizzbuzz_key
    subject.new.methods.must_include :fizzbuzz_key=
  end

  it "raises an error if either just the setter or getting method is already defined" do
    proc {
      subject.infect_an_attribute(:new?)
    }.must_raise TownCrier::Error
  end
end
