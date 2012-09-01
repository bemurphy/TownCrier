require 'ost'

module TownCrier
  class Queue
    QUEUE_NAME = :town_crier_queue

    def self.<<(event)
      Ost[QUEUE_NAME] << event.to_json
    end
  end
end
