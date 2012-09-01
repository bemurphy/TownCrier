module TownCrier
  class UserLookup
    def self.recipients(event_binding)
      User.with_event_binding(event_binding)
    end
  end
end
