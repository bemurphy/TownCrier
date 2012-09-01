module TownCrier
  class MultiChannel
    attr_accessor :channels

    def initialize(channels)
      @channels = channels
    end

    def publish(event)
      #TODO this needs exception handling and logging
      channels.each { |c| c.publish(event) }
    end
  end
end
