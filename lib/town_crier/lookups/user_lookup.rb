module TownCrier
  class UserLookup
    attr_reader :contact_key
    def contact_key=(key)
      User.infect_an_attribute key
      @contact_key = key
    end

    def recipients(event_binding)
      User.with_event_binding(event_binding)
    end
  end
end
