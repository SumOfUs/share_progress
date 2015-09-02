# ShareProgress

`ShareProgress` is a gem designed to make creating A/B tests of Share Buttons for advocacy webpages simple and direct. It wraps the ShareProgress HTTP API while providing a simple, ActiveRecord-like interface for creating, updating and deleting buttons on ShareProgress.org itself.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'share_progress'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install share_progress

## Usage

The current version of `share_progress` is centered around `Button` and `Variant` classes. Currently, this gem wraps a subset of the [ShareProgress API](https://docs.google.com/document/d/1f1Jktt4gk9b3qugH8h-3bj6DoijQ3_6-RxUw5uq7DWU/edit#) intended to work within applications that need to create share buttons for use on their website. 

Before beginning, the application will expect that your environment defines an Environment Variable named `SHARE_PROGRESS_API_KEY`. This key can be retrieved for your account from run.shareprogress.org. 

`ShareProgress` defines an API for interacting with the button portion of the ShareProgress API that is similar to ActiveRecord. Creating a new button is as simple as calling `Button.new(params)` where the params in question are the variables of the button (see [Button parameter options](https://docs.google.com/document/d/1f1Jktt4gk9b3qugH8h-3bj6DoijQ3_6-RxUw5uq7DWU/edit#heading=h.66d9v1vnsmth) for more details). Button variants (which define A/B/X testing variants for testing share options on ShareProgress) can be added by setting the `variants` property of your created button, or added through the `add_or_update(variant)` method. Button variants can be defined as hashes containing the correct parameters (options for Variant values can be seen in the sample request in [the documentation](https://docs.google.com/document/d/1f1Jktt4gk9b3qugH8h-3bj6DoijQ3_6-RxUw5uq7DWU/edit#heading=h.mdykzbbhavff)) or by passing in instances of the `FacebookVariant`, `TwitterVariant` and `EmailVariant` classes. 

To create or update your button and its variants, simply call `button.save`, which will marshal all your changes and submit them to the API. If the request is successful, `save` will return `true`, while errors will cause the method to return `false` and `button.errors` will contain the relevant errors on the save attempt.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SumOfUs/share_progress.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

