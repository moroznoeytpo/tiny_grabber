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


# Initialize request setting

# Set request timelive
read_timeout = 300

# You can set own UserAgent, but by default each request get random UserAgent from list of most popular
user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36'

# Set proxy for concealment your real IP
# ip(required argument) - String format [0-9]+\.[0-9]+\.[0-9]+\.
# port(required argument) - Integer
# type - Connect type `http` or `socks`
proxy = { ip: 'xx.xx.xx.xx', port: 'xxxx', type: '...' }

# Set Net::HTTP headers
headers = { 'Content-Type' => 'text/html; charset=utf-8' }

# You can set own cookies like String or Hash
cookies = 'username=username&password=password'
cookies = { username: 'username', password: 'password' }

# For POST request you can set DATAS
params = { key: 'value' }

# Initialize TinyGrabber object
tg = TinyGrabber.new


# Set debug configuration
# active - Flag to save log information
# destination - Save log to file or print: [:file, :print]
# save_html - Flag to save response html to file
tg.debug = { active: true, destination: :file, save_html: true }

# Set debug flag for activate debug with default configuration { active: true, destination: :print, save_html: false }
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
tg.headers = headers

# Set HTTP cookies
tg.cookies = cookies


# Make request

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


# Get response

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

* *v 0.2.6*
    * Move read_timeout param to agent start method
* *v 0.2.5*
    * Added auto convert params to symbol
    Now you can set cookies with hash `cookies = { "username" => 'username', "password" => 'password' }`
* *v 0.2.4*
    * Added debug file
* *v 0.2.3*
    * The feature to set cookies in the form of a Hash is added
* *v 0.2.2*
    * Added debug configurations.
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

