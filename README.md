# Cryptsy::Ruby

A first stab at a Ruby implementation of the Cryptsy API.

## Installation

Add this line to your application's Gemfile:

    gem 'cryptsy-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cryptsy-api

## Usage

    require 'cryptsy/api'

    cryptsy = Cryptsy::API::Client.new(key, secret)
    
    e.g. cryptsy.getinfo

    NOTE: Public APIs don't require a key or secret

    All apis have been implemented except the deprecated v1 marketdata

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
