require "town_crier/version"
require "json"
require "ohm"
require "ohm/contrib"
require "ostruct"
require "securerandom"

module TownCrier
  QUEUE_NAME = :town_crier_queue

  Error = Class.new(StandardError)

  def self.config
    init_config
    @_config
  end

  def self.freeze_config
    @_config.freeze
  end

  def self.init_config(force = false)
    @_config = nil if force
    @_config ||= OpenStruct.new
  end

  def self.generate_token
    SecureRandom.urlsafe_base64(32).tr('-_', '')[0,30]
  end

  class << self
    # The channel workers should publish to.
    # Outside of testing this will likely
    # always be a MultiChannel so you can publish
    # to multiple channels from workers
    attr_accessor :active_channel
  end
end

require_relative "town_crier/channel"
require_relative "town_crier/channels/email_channel"
require_relative "town_crier/channels/multi_channel"
require_relative "town_crier/channels/pushover_channel"
require_relative "town_crier/channels/sms_channel"
require_relative "town_crier/event"
require_relative "town_crier/event_binding"
require_relative "town_crier/lookups/user_lookup"
require_relative "town_crier/queue"
require_relative "town_crier/server"
require_relative "town_crier/user"
require_relative "town_crier/view"
require_relative "town_crier/view_resolver"
require_relative "town_crier/worker"

