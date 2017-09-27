# Handshaker

Handshaker is a Ruby gem for implementing multi-strategy Collaborative Transactional Validation
(CTV). If you're not familiar with the concept, fear not, because it's something we just made up
at Batteries 911.

CTV is a process where multiple parties cooperate to validate the integrity of a transaction. You
can think of it as a very sophisticated `if` check, that might potentially involve tens of different
conditions.

At Batteries 911, CTV is employed during the cross-docking handshake process (hence the name of the
gem), where two users validate the integrity of the inventory that is being transferred.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'handshaker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install handshaker

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run 
the tests. You can also run `bin/console` for an interactive prompt that will allow you to 
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new 
version, update the version number in `version.rb`, and then run `bundle exec rake release`, which 
will create a git tag for the version, push git commits and tags, and push the `.gem` file to 
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/batteries911/handshaker.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
