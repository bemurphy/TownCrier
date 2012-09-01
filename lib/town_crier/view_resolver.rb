module TownCrier
  class ViewResolver
    attr_accessor :event_binding

    def initialize(event_binding)
      @event_binding = event_binding
    end

    def resolve
      parts = [event_binding.namespace, event_binding.type, event_binding.action, event_binding.channel, "View"].map(&:capitalize)

      # Exact match
      if Object.const_defined? parts.join
        return Object.const_get(parts.join)
      end

      # No namespace match
      if Object.const_defined? parts[1..-1].join
        return Object.const_get(parts[1..-1].join)
      end

      # Namespace but no channel
      ns_no_channel = (parts[0,3] << parts.last).join
      if Object.const_defined? ns_no_channel
        return Object.const_get(ns_no_channel)
      end

      # Type and action only
      type_and_action = (parts[1,2] << parts.last).join
      if Object.const_defined? type_and_action
        return Object.const_get(type_and_action)
      end

      # Default
      TownCrier::View
    end
  end
end
