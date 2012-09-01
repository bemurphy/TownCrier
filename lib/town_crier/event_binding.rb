module TownCrier
  class EventBinding
    attr_accessor :namespace, :type, :action, :channel

    def initialize(params)
      @namespace = params.fetch(:namespace)
      @type      = params.fetch(:type)
      @action    = params.fetch(:action)
      @channel   = params.fetch(:channel)
    end

    def self.from_string(string)
      parts = string.split('.', 4)
      new({
        :namespace => parts[0],
        :type      => parts[1],
        :action    => parts[2],
        :channel   => parts[3]
      })
    end

    def to_s
      [namespace, type, action, channel].join('.')
    end

    def ==(other)
      to_s == other.to_s
    end
  end
end
