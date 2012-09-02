module TownCrier
  class Channel
    attr_accessor :lookup, :options

    def initialize(lookup, options = {})
      @lookup = lookup
      @options = options
      self.class.register(lookup)
    end

    def publish(event)
      # implement this yourself
    end

    def recipients(event)
      lookup.recipients(event_binding(event))
    end

    def self.register(lookup)
      #no-op
    end

    def self.key
      if self == TownCrier::Channel
        "channel"
      else
        name = self.name.split('::').last
        name.gsub(/Channel$/, '').downcase
      end
    end

    def key
      self.class.key
    end

    def event_binding(event)
      EventBinding.from_string([event.key, key].join('.'))
    end

    def view(event)
      binding = event_binding(event)
      view_class = ViewResolver.new(binding).resolve
      view_class.new(event)
    end
  end
end
