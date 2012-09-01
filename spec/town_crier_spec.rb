require_relative "spec_helper"

describe TownCrier do
  before { TownCrier.init_config(:force) }
  after { TownCrier.init_config(:force) }

  it "allows assigning arbitrary values off TownCrier.config" do
    TownCrier.config.foo.must_be_nil
    TownCrier.config.foo = "bar"
    TownCrier.config.foo.must_equal "bar"
  end

  it "allows freezing the config to prevent runtime changes" do
    TownCrier.config.foo = "bar"
    TownCrier.freeze_config
    proc {
      TownCrier.config.foo = "BAR!"
    }.must_raise TypeError
  end
end
