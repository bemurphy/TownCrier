module TownCrier
  class Channel
    attr_accessor :lookup, :options

    def initialize(lookup, options = {})
      @lookup = lookup
      @options = options
    end

    def publish(event)
      # implement this yourself
    end

    def recipients(event)
      event_binding = EventBinding.from_string([event.key, "channel"].join('.'))
      lookup.recipients(event_binding)
    end
  end
end
