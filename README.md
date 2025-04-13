<p align="center">
  <img src="https://cdn.evntaly.com/Resources/og.png" alt="Evntaly Cover" width="100%">
</p>

<h3 align="center">Evntaly</h3>

<p align="center">
 An advanced event tracking and analytics platform designed to help developers capture, analyze, and react to user interactions efficiently.
</p>
<p align="center">
  <a href="https://rubygems.org/gems/evntaly">
    <img src="https://img.shields.io/gem/v/evntaly" alt="Gem Version">
  </a>
  <a href="https://github.com/Evntaly/evntaly-ruby"><img src="https://img.shields.io/github/license/Evntaly/evntaly-ruby" alt="license"></a>
</p>

# evntaly-ruby
**EvntalySDK** is a ruby gem for interacting with the Evntaly event tracking platform. It provides methods to initialize tracking, log events, identify users, and check API usage limits.

## Features

- **Initialize** the SDK with a developer secret and project token.
- **Track events** with metadata and tags.
- **Identify users** for personalization and analytics.
- **Enable or disable** tracking globally.

## Installation

To install the SDK using `bundler`:

```sh
 gem 'evntaly', '~> 1.0'
```
and then run:
```
bundle install
```

or install directly using:
```
gem install evntaly
```

## Usage

### Initialization

Initialize the SDK with your developer secret and project token:

```ruby
sdk = Evntaly::SDK.new(
    developer_secret: 'YOUR_DEVELOPER_SECRET',
    project_token: 'YOUR_PROJECT_TOKEN'
)
```

### Tracking Events

To track an event:

```ruby
 event = Evntaly::Event.new(
  title: 'User Signed Up',
  description: 'A new user signed up to the platform.',
  message: 'Welcome email sent to the user.',
  data: { plan: 'pro', referrer: 'campaign_xyz' },
  tags: ['signup', 'email', 'marketing'],
  notify: true,
  icon: "💰",
  apply_rule_only: false,
  user: { id: '12345' },
  type: 'user_event',
  session_id: 'session_abc',
  feature: 'onboarding',
  topic: 'user_activity'
)

begin
  sdk.track(event)
rescue => e
  # error handling logic
end
```

### Identifying Users

To identify a user:

```ruby
user = Evntaly::User.new(
  id: 'u123',
  email: 'user@example.com',
  full_name: 'John Doe',
  organization: 'Example Org',
  data: { role: 'admin' }
)

begin
  sdk.identify_user(user)
rescue => e
  # error handling logic
end
```

### Enabling/Disabling Tracking

Control event tracking globally:

```ruby
 Evntaly::SDK.disable_tracking  # Disables tracking
 Evntaly::SDK.enable_tracking   # Enables tracking
```
And to check if tracking is enabled, do:
```ruby
 Evntaly::SDK.tracking_enabled?
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake gh-release`, which will create a git tag for the version.

## License

This project is licensed under the MIT License.

---

*Note: Replace **`"YOUR_DEVELOPER_SECRET"`** and **`"YOUR_PROJECT_TOKEN"`** with actual credentials.*