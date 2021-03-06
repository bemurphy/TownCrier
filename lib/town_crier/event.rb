module TownCrier
  class Event
    attr_reader :event_hash

    def initialize(event_hash)
      @event_hash = event_hash.dup
    end

    def self.from_json(json)
      new JSON.parse(json)
    end

    def to_json
      event_hash.to_json
    end

    def namespace
      event_hash["namespace"] || "default"
    end

    def type
      event_hash.fetch("type")
    end

    def action
      event_hash.fetch("action")
    end

    def timestamp
      @timestamp ||= event_hash["timestamp"] || Time.now.to_i
    end

    def key
      [namespace, type, action].join('.')
    end

    def meta
      event_hash["meta"] || {}
    end

    def ==(other)
      other.is_a?(self.class) && event_hash == other.event_hash
    end

    def valid?
      begin
        !! (type && action)
      rescue KeyError
        false
      end
    end

    def respond_to?(symbol, include_private = false)
      symbol.to_s.index("meta_") == 0 ? true : super
    end

    def method_missing(meth, *args, &blk)
      if meth.to_s =~ /^meta_(.+)$/
        meta[$1]
      else
        super
      end
    end
  end
end
