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

read_timeout = 300
user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36'
proxy = { ip: 'xx.xx.xx.xx', port: 'xxxx' }
headers1 = { 'Content-Type' => 'text/html; charset=utf-8' }
headers2 = { 'Content-Type' => 'text/html; charset=utf-8', 'Connection' => 'keep-alive' }
cookies = 'username=username&password=password'
params = { key: 'value' }

# Initialize TinyGrabber object
tg = TinyGrabber.new
# Set debug flag for view log information
tg.debug = true
# Set max time to execute request
tg.read_timeout = read_timeout
# Set web browser name
tg.user_agent = user_agent
# Set proxy configuration
tg.proxy = proxy
# Set basic authentification
tg.basic_auth('username', 'password')
# Set HTTP headers
tg.headers = headers1
# Set HTTP cookies
tg.cookies = cookies

# Make response with GET method
response = tg.get 'https://whoer.net/ru', headers
# Reset headers and cookies
tg.reset
# Make response with POST method
response = tg.post 'https://whoer.net/ru', params, headers


# Make singleton response with GET method
response = TinyGrabber.get 'https://whoer.net/ru', { debug = true, read_timeout = read_timeout ... }
# Make singleton response with POST method
response = TinyGrabber.post 'https://whoer.net/ru', params, { debug = true, read_timeout = read_timeout ... }

# Get Nokogiri object from response HTML
ng = response.ng
# Get HTTP response code
response.code
# Get response cookies
response.cookies
# Get response headers
response.headers
# Get response HTML
response.body
```

## Changelog

* *v 0.2.1*
    * Setting random user_agent from list if it not seted
    * Remove headers attribute from singleton methods
    * Remove header transfer-encoding for chain requests
    * Add reset method for delete headers and cookies

* *v 0.2.0*
    * Now there is an opportunity to create object TinyGrabber
    * Change order of parameters for singleton request
    * Add response cookies and headers
    * Add debug flag for detilazition log and save result HTML to /log/*.html file

* *v 0.1.1*
    * Save cookie in Redis
* *v 0.1.0*
    * Add TinyGrabber.post method for HTTP POST request
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

