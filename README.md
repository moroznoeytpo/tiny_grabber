# TinyGrabber

[<img src="https://badge.fury.io/rb/tiny_grabber.svg" alt="Gem Version" />](https://badge.fury.io/rb/tiny_grabber)

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

require 'tiny_grabber'

# Link to remote site
url = 'https://github.com/moroznoeytpo/tiny_grabber'

# Set headers
headers = { 'Content-Type' => 'application/json' }

# Set http(s)/socks4(5) proxy
# Proxy type by default is http. You can change it to socks, with setting params proxy_type equal socks
proxy = { ip: 'xx.xx.xx.xx', port: xx, proxy_type: :socks }

# Set Basic Authentication
auth = { username: '', password: '' }

# Set POST data
# Request HTTP type by default is GET. You can send POST request with setting post params. Also you cat send empty POST request.
post = { some_data: '' }

# Get response
response = TinyGrabber.get url, headers: headers, proxy: proxy, auth: auth, post: post

# HTTP answer code
p response.code

# HTTP content
p response.body

# Nokogiri object
p response.ng

# Response cookies
p response.cookies
```

## Changelog

* *v 0.0.7*
    * Add POST request
    * Add Basic Authentication
* *v 0.0.6*
    * Add Net::HTTPOK modify file for Nokogiri response
* *v 0.0.5*
    * Fix work with non ascii url
    * Add new `ng` response method for getting Nokogiri object
* *v 0.0.4*
    * Fix work with socks4(5) proxy

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Dependencies

* [net/http](http://ruby-doc.org/stdlib-2.3.0/libdoc/net/http/rdoc/Net/HTTP.html)
* [uri](http://ruby-doc.org/stdlib-2.3.0/libdoc/uri/rdoc/URI.html)
* [socksify](http://socksify.rubyforge.org/)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moroznoeytpo/tiny_grabber. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Authors

Copyright © 2016 by Aleksandr Chernyshov (moroznoeytpo@gmail.com)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Gem created by [quickleft tutorial](https://quickleft.com/blog/engineering-lunch-series-step-by-step-guide-to-building-your-first-ruby-gem/)

