module TownCrier
  class View
    attr_accessor :event

    def initialize(event)
      @event = event
    end

    def title
      "#{event.key} event"
    end

    def message
      "#{title} at #{Time.at(event.timestamp)}"
    end
  end
end
