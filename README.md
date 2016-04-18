# TinyGrabber

The TinyGrabber library is used for grabbing remote websites.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tiny_grabber'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tiny_grabber

## Usage

```ruby
#! /usr/bin/env ruby

require 'tiny-grabber'

# Link to remote site
url = 'https://github.com/moroznoeytpo/tiny-grabber'

# Set headers
headers = { 'Content-Type' => 'application/json' }

# Set http(s)/socks4(5) proxy
proxy = { ip: 'xx.xx.xx.xx', port: xx, proxy_type: :socks }

# Get response
response = TinyGrabber.get url, headers: headers, proxy: proxy

# HTTP answer code
p response.code

# HTTP content
p response.read_body
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Dependencies

* {net/http}[http://ruby-doc.org/stdlib-2.3.0/libdoc/net/http/rdoc/Net/HTTP.html]
* {uri}[http://ruby-doc.org/stdlib-2.3.0/libdoc/uri/rdoc/URI.html]
* {socksify}[http://socksify.rubyforge.org/]

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moroznoeytpo/tiny_grabber. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Authors

Copyright © 2016 by Aleksandr Chernyshov (moroznoeytpo@gmail.com)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Gem created by [quickleft tutorial](https://quickleft.com/blog/engineering-lunch-series-step-by-step-guide-to-building-your-first-ruby-gem/)

