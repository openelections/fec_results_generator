# FecResultsGenerator

A Ruby gem that takes Federal Election Commission election results as retrieved by the FecResults gem and generates JSON files in a directory structure, suitable for producting a static API. You can see an example of the data at the [FecResults site](http://openelections.github.io/fec_results/api/2012/summary/general_election_votes.json).

## Installation

Add this line to your application's Gemfile:

    gem 'fec_results_generator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fec_results_generator

## Usage

In `irb`, create an instance of the JSONGenerator class:

```ruby
g = FecResultsGenerator::JsonGenerator.new(:year => 2000)
g.congress  # for congressional results
g.president # for presidential results
g.summary  # for vote totals
```


## Contributing

1. Fork it ( http://github.com/<my-github-username>/fec_results_generator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
