# TownCrier

TownCrier - Multi Channel short announcement service for your organization

What's it used for?
-------------------

After running a few different apps, you start to notice a pattern.  Often,
you will send out quick notifications to your team for certain app events;
Fizzbuzz app has created an account! PictureAppDujour got a membership plan
upgrade!

Rather than building notifications, recipient lists, and message formatting for
these concerns into different apps, TownCrier allows you to consolidate
notifications into a service app.

How does it do this?
--------------------

TownCrier provides a web service with an events api endpoint at `/api/v1/events`.
The events API receives JSON posted data that is mostly agnostic.  There's two
requirements to posted event data:  it must have a `type` and an `action` attribute.

Here's what a parsed example event might look like:

```ruby
{
  "namespace" => "fizzbuzz",
  "type"   => "account",
  "action" => "create",
  "meta"   => {
    "id"   => 42,
    "plan" => "gold"
  }
}
```

Note it's got a `namespace` property there.  That's optional;  it will get set
to `default` if not provided.  The namespace can be used to distinguish
different systems or apps.

Also take note of the `meta` attribute.  Metadata is additional data about the
event you want available for the message.  TownCrier makes no assumptions
about the data;  it is passed to make available in views.

Views, you say?
---------------

Rather than making your remote apps responsible for the formatted content of
messages, TownCrier enables them to provide data and take care of the message
format itself.  A TownCrier view will typically provide `title` and
`message` methods for the delivered messages.  For example:

```ruby
class AccountCreateView < TownCrier::View
  def title
    "Account Created"
  end

  def message
    "An account with plan #{event.meta_plan} was created! Party time!"
  end
end
```

The view has access to the event being published, so you can include event
data in the message you are crafting.  Access to metadata can be accessed
via `#meta_key` methods as shown above.

What's all this namespace/type/action stuff for?
------------------------------------------------

TownCrier uses event and channel data for building an `EventBinding`.  If
you've ever used a pubsub system, or AMQP, it's kind of like a routing key.
You can imagine an event binding to look like `namespace.type.action.channel`.

The event binding allows a user to choose to receive notices about given
events on a certain channel.  For instance, a binding of
`default.account.create.pushover` would send me notices about account creation
via the pushover channel, while `default.account.destroy.sms` would send them
to me via sms.  This enables users to pick not only what they get notified
about, but how.

The event bindings also serve a second purpose, resolving view templates for
messages.  Template resolution for building a message checks for view classes
in a specific to less specific order.  An event binding for
`foo.account.create.sms` would first lookup the `FooAccountCreateSmsView`.  If
that's not found, it will skip the namespace and look for
`AccountCreateSmsView`.  If the channel is not found, it will simply lookup
`AccountCreateView`.  Finally, if nothing is found, it will fall back to the
`TownCrier::View` as a default.

Channels
--------

Channels provide the medium for sending a notification.  TownCrier currently
ships with channels for Pushover, SMS, and Email.  It also features a Multi
channel, which aggregates multiple channels for sending out in serial.  This
enables a worker to publish to a MultiChannel instance, which is configured to
publish out over SMS, Email, etc.

Channels are initialized with a Lookup that should provide a `recipients`
method that accepts an event binding and looks for interested recipients.
Currently, a `UserLookup` is provided for finding users with specific
bindings.

For instance, you may want to enable an email channel that publishes every
notice to the noc and ops email addresses:

```ruby
class NocOps < TownCrier::UserLookup
  def recipients(*)
    [
      OpenStruct.new(:email => "noc@example.com"),
      OpenStruct.new(:email => "ops@example.com")
    ]
  end
end

email_channel = TownCrier::EmailChannel.new(NocOps.new, email_config)
```

Creating an EmailChannel and injecting this lookup will ensure they're always
notified about everything.  You've been warned!

## Installation

Add this line to your application's Gemfile:

    gem 'town_crier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install town_crier

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
