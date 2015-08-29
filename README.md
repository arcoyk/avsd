# Avsd

###THIS GEM IS UNDEREXPERIMENT

Avsd is AVSD Recommend Algorithm implimatation on Ruby gem. AVSD Recommend Algorithm recommends sets of items based on multiple exisiting sets of items with a measure of creativity.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'avsd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install avsd

## Usage

```ruby
avsd = Avsd.new [['carotte','potate','beaf','curry paste'],['beaf','potates','oregano'],['oregano', 'tomato', 'garlic']]
avsd.sample 3
# [{"tomato"=>6, "garlic"=>7, "curry paste"=>3}, [2.0, 6.0, 6.0], 4.666666666666667, 1.8856180831641267]
# Here the creativity is 1.8 / 4.6 = 0.3
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arcoyk/avsd.

