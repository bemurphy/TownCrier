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
      event_binding = EventBinding.from_string([event.key, key].join('.'))
      lookup.recipients(event_binding)
    end

    def key
      if self.class == TownCrier::Channel
        "channel"
      else
        name = self.class.name.split('::').last
        name.gsub(/Channel$/, '').downcase
      end
    end
  end
end
