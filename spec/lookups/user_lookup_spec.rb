require_relative '../spec_helper'

describe TownCrier::UserLookup do
  let(:user) { TownCrier::User.create(:name => "Joe", :email => "joe@example.com") }
  let(:event_binding) {
    TownCrier::EventBinding.new(:namespace => "ns", :type => "account", :action => "create", :channel => "email")
  }
  subject { TownCrier::UserLookup.new }

  it "has a default contact_key of :email" do
    subject.contact_key.must_equal :email
  end

  it "infects the user with the attribute for the lookup key" do
    subject.contact_key = :test_key
    subject.contact_key.must_equal :test_key
    TownCrier::User.new.methods.must_include :test_key
  end

  it "finds users with the given event binding" do
    subject.recipients(event_binding).wont_include user
    user.add_event_binding(event_binding)
    subject.recipients(event_binding).must_include user

    jane = TownCrier::User.create(:name => "Jane", :email => "jane@example.com")
    jane.add_event_binding(event_binding)
    subject.recipients(event_binding).must_include user
    subject.recipients(event_binding).must_include jane
  end
end
