module TownCrier
  class User < Ohm::Model
    attribute :name
    attribute :email

    index :event_binding

    def validate
      assert_present :name
      assert_present :email
      assert_format :email, /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    end

    def event_bindings
      event_bindings_key.smembers
    end

    def event_binding
      event_bindings
    end

    def add_event_binding(event_binding)
      event_bindings_key.sadd(event_binding) && save
    end

    def remove_event_binding(event_binding)
      event_bindings_key.srem(event_binding) && save
    end

    def bound_to?(event_binding)
      event_bindings_key.sismember(event_binding)
    end

    def self.with_event_binding(event_binding)
      find(:event_binding => event_binding)
    end

    protected

    def event_bindings_key
      key[:event_bindings]
    end
  end
end
