require 'rushover'

module TownCrier
  class PushoverChannel < Channel
    def initialize(*)
      super
      lookup.contact_key = :pushover_key
    end

    def publish(event)
      view = view(event)

      recipients(event).each do |user|
        next if user.pushover_key.to_s.empty?
        client.notify(user.pushover_key, view.message, :title => view.title)
      end
    end

    def client
      @client ||= Rushover::Client.new(options.fetch(:token))
    end
  end
end

