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

The simplest example we can provide of CTV is two users, Bob and Alice, confirming a transaction, 
each with their own password.

```ruby
transaction = Handshaker::Transaction::Strict.new(steps: [
  Handshaker::Step::Literal.new(answer: 'Secret123', party: bob),
  Handshaker::Step::Literal.new(answer: 'Secret456', party: alice)
])

transaction.valid? # => false

transaction.contribute_as(alice, with: 'Secret456') # => Handshaker::Contribution
transaction.valid? # => false

transaction.contribute_as(bob, with: 'Secret789') # => Handshaker::Contribution
transaction.valid? # => false
 
transaction.contribute_as(bob, with: 'Secret123') # => Handshaker::Contribution
transaction.valid? # => true
```

As you can see, the transaction was only valid once both Bob and Alice had both entered their 
passwords.

Not impressed yet? Read on.

### Resolution strategies

Transactions can be resolved in different ways. For instance, consider the following scenario:
Bob and Alice want are going on a trip together and they must agree on how much they want to spend.
In this case, we don't care about them entering an exact value in the system, we just want them to
enter _the same value_ before we allow the transaction to continue.

This type of transaction is a joint-resolution transaction, which is represented by a 
`Handshaker::Transaction::Joint` object:

```ruby
transaction = Handshaker::Transaction::Joint.new(steps: [
  Handshaker::Step::Open.new(party: bob),
  Handshaker::Step::Open.new(party: alice)
])

transaction.valid? # => false

transaction.contribute_as(alice, with: 500) # Alice wants to spend 500 USD
transaction.valid? # => false

transaction.contribute_as(bob, with: 1000) # Bob wants to spend 1000 USD
transaction.valid? # => false

transaction.contribute_as(alice, with: 1000) # Alice agrees to spend 1000 USD
transaction.valid? # => true
```

### Order enforcement

We can enforce the order in which the steps are executed. This can be useful, for instance, if you
want to collect decisions in a specific order. For instance, in a sale transaction you might want to
verify that the seller confirms delivery before the buyer confirms reception.

Here we actually introduce three new concepts: the `Boolean` step, which only accepts a yes/no 
answer, the `AllIn` resolution, which ensures everyone replied "yes", and the `ordered` property,
which forbids a user to contribute if the previous user has not contributed yet.

```ruby
transaction = Handshaker::Transaction::AllIn.new(
  steps: [
    Handshaker::Step::Boolean.new(party: bob),
    Handshaker::Step::Boolean.new(party: alice)
  ],
  ordered: true
)

transaction.valid? # => false

transaction.contribute_as(alice, with: true) # raises Handshaker::OrderError

transaction.contribute_as(bob, with: true)
transaction.valid? # => false

transaction.contribute_as(alice, with: true)
transaction.valid? # => true
```

(In case you're wondering, yes, we also have an `AllOut` transaction.)

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

## Todo

- `transaction.missing_steps`
- `transaction.invalid_steps`
- `transaction.missing_users`
- `transaction.invalid_users`
- Transaction locking once validated
