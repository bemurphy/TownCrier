module TownCrier
  class UserLookup
    def contact_key
      @contact_key || :email
    end

    def contact_key=(key)
      User.infect_an_attribute key
      @contact_key = key.to_sym
    end

    def recipients(event_binding)
      users = User.with_event_binding(event_binding)
      users.reject { |u| u.send(contact_key).to_s.empty? }
    end
  end
end
