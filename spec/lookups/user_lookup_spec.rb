require_relative '../spec_helper'

describe TownCrier::UserLookup do
  let(:user) { TownCrier::User.create(:name => "Joe", :email => "joe@example.com") }
  let(:event_binding) {
    TownCrier::EventBinding.new(:namespace => "ns", :type => "account", :action => "create", :channel => "email")
  }

  it "finds users with the given event binding" do
    TownCrier::UserLookup.recipients(event_binding).wont_include user
    user.add_event_binding(event_binding)
    TownCrier::UserLookup.recipients(event_binding).must_include user

    jane = TownCrier::User.create(:name => "Jane", :email => "jane@example.com")
    jane.add_event_binding(event_binding)
    TownCrier::UserLookup.recipients(event_binding).must_include user
    TownCrier::UserLookup.recipients(event_binding).must_include jane
  end
end
