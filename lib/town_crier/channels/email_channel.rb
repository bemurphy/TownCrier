require "pony"

module TownCrier
  class EmailChannel < Channel
    def publish(event)
      view = view(event)

      to = recipients(event).map(&:email)
      return unless to.length > 0

      Pony.mail options.merge({
        :to => to,
        :via => :smtp,
        :subject => view.title,
        :body => view.message
      })
    end
  end
end
