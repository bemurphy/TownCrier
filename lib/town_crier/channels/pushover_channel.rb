require 'rushover'

module TownCrier
  class PushoverChannel < Channel
    def self.register(lookup = TownCrier::UserLookup.new)
      lookup.contact_key = :pushover_key if lookup.respond_to?(:contact_key=)
    end

    def publish(event)
      view = view(event)

      recipients(event).each do |user|
        client.notify(user.pushover_key, view.message, :title => view.title)
      end
    end

    def client
      @client ||= Rushover::Client.new(options.fetch(:token))
    end
  end
end

