require_relative 'spec_helper'

describe TownCrier::Queue do
  def event_hash
    {
      "type"      => "account",
      "action"    => "create",
      "meta"      => {
        "id"   => 42
      }
    }
  end

  let(:event) { TownCrier::Event.new(event_hash) }

  before do
    Ost[:town_crier_queue].key.del
  end

  it "pushes the json for events onto the Ost[:town_crier_queue]" do
    TownCrier::Queue << event
    enqueued = Ost[:town_crier_queue].key.lpop
    enqueued.must_equal event.to_json
  end
end
