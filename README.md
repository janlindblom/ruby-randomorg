# RandomOrg

Access true random numbers through the random.org API!

See https://random.org/ for the specifics of the random.org services and their [API](https://api.random.org/json-rpc/1/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'randomorg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install randomorg

## Usage

Before you can get your random numbers, you will need an API key. You can request one from here: https://api.random.org/api-keys/beta

Then you need to configure the module with this key in order to use the service:

```
RandomOrg.configure do |config|
  config.api_key = "YOUR_API_KEY"
end
```

After which you can use it in pretty much the same way as you would the SecureRandom library:

```
> RandomOrg.random_number(100)
=> 78
> RandomOrg.base64
=> "r1nwqJksqKacn26UBI1GkQ=="
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on Bitbucket at https://bitbucket.org/janlindblom/ruby-randomorg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Use of the random.org service and API is subject to their Terms and Conditions: https://www.random.org/terms/
