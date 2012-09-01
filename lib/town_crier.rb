require "town_crier/version"
require "json"
require "ohm"
require "ostruct"

module TownCrier
  QUEUE_NAME = :town_crier_queue

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
end

require_relative "town_crier/channel"
require_relative "town_crier/channels/pushover_channel"
require_relative "town_crier/event"
require_relative "town_crier/event_binding"
require_relative "town_crier/lookups/user_lookup"
require_relative "town_crier/queue"
require_relative "town_crier/server"
require_relative "town_crier/user"
require_relative "town_crier/view"
require_relative "town_crier/view_resolver"

