require 'twilio-ruby'

module TownCrier
  class SmsChannel < Channel
    def initialize(*)
      super
      lookup.contact_key = :mobile_number
    end

    def publish(event)
      view = view(event)

      recipients(event).each do |user|
        client.account.sms.messages.create(
          :from => options[:from],
          :to   => user.mobile_number,
          :body => view.message
        )
      end
    end

    def client
      @client ||= Twilio::REST::Client.new options[:account_sid], options[:auth_token]
    end
  end
end
