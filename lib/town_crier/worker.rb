require 'ost'
require 'json'

module TownCrier
  class Worker
    def self.run
      Ost[TownCrier::Queue::QUEUE_NAME].each do |json|
        event = TownCrier::Event.from_json(json)
        TownCrier.active_channel.publish(event)
      end
    end
  end
end
