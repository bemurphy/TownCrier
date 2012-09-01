require 'ost'

module TownCrier
  class Queue
    def self.<<(event)
      Ost[:town_crier_queue] << event.to_json
    end
  end
end
