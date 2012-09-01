module TownCrier
  class UserLookup
    def self.infect_an_attribute(attribute)
      User.infect_an_attribute attribute
    end

    def self.recipients(event_binding)
      User.with_event_binding(event_binding)
    end
  end
end
