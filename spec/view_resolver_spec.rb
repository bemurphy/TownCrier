require_relative 'spec_helper'

describe TownCrier::ViewResolver do
  let(:event_binding) { TownCrier::EventBinding.from_string("ns.account.create.email") }
  subject { TownCrier::ViewResolver.new(event_binding)}

  it "initializes with an event binding" do
    subject = TownCrier::ViewResolver.new(event_binding)
    subject.event_binding.must_equal event_binding
  end

  it "finds the view class for the specific event binding if it exists" do
    with_temp_class "NsAccountCreateEmailView" do
      subject.resolve.must_equal NsAccountCreateEmailView
    end
  end

  it "falls back to finding the view class without the namespace in it" do
    with_temp_class "AccountCreateEmailView" do
      subject.resolve.must_equal AccountCreateEmailView
    end
  end

  it "falls back to finding the view class with the namespace but no channel key in it" do
    with_temp_class "NsAccountCreateView" do
      subject.resolve.must_equal NsAccountCreateView
    end
  end

  it "falls back to finding the view class with no namespace and no channel" do
    with_temp_class "AccountCreateView" do
      subject.resolve.must_equal AccountCreateView
    end
  end

  it "finally falls back to View" do
      subject.resolve.must_equal TownCrier::View
  end
end
