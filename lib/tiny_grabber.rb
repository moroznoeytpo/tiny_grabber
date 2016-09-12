require 'tiny_grabber/version'
require 'tiny_grabber/agent'
require 'tiny_grabber/debug'

require 'uri'
require 'net/http'
require 'socksify/http'
require 'tiny_grabber/http'

# Main class for TinyGrabber
#
class TinyGrabber
  # Initialize a new TinyGrabber user agent.
  #
  def initialize
    @agent = TinyGrabber::Agent.new
  end

  # Singleton > Initialize a new TinyGrabber user agent.
  #
  def self.initialize(config = {})
    @agent = TinyGrabber::Agent.new

    @agent.debug = config[:debug] if config[:debug]
    @agent.read_timeout = config[:read_timeout] if config[:read_timeout]
    @agent.user_agent = config[:user_agent] if config[:user_agent]
    @agent.proxy = config[:proxy] if config[:proxy]
    @agent.basic_auth = config[:basic_auth] if config[:basic_auth]
    @agent.headers = config[:headers] if config[:headers]
    @agent.cookies = config[:cookies] if config[:cookies]
  end

  # HTTP::GET request
  #
  # @param url Resource link
  # @param headers Request header
  #
  def get(url, headers = {})
    @agent.fetch url, :get, headers
  end

  # Singleton > HTTP::GET request
  #
  # @param url Resource link
  # @param headers Request header
  #
  def self.get(url, config = {})
    initialize config
    @agent.fetch url, :get
  end

  # HTTP::POST request
  #
  # @param url Resource link
  # @param params Request post data
  # @param headers Request header
  #
  def post(url, params = {}, headers = {})
    @agent.fetch url, :post, headers, params
  end

  # Singleton >  HTTP::GET request
  #
  # @param url Resource link
  # @param headers Request header
  #
  def self.post(url, params = {}, config = {})
    initialize config
    @agent.fetch url, :post, {}, params
  end

  # Set DEBUG flag
  #
  # @param debug Flag to start debug
  #
  def debug=(debug)
    @agent.debug = debug
  end

  # Read READ_TIMEOUT agent attribute
  #
  def read_timeout
    @agent.read_timeout
  end

  # Set READ_TIMEOUT agent attribute
  #
  # @param read_timeout Waiting time to reading
  #
  def read_timeout=(read_timeout)
    @agent.read_timeout = read_timeout
  end

  # Read USER_AGENT agent attribute
  #
  def user_agent
    @agent.user_agent
  end

  # Set USER_AGENT agent attribute
  #
  # @param user_agent Web browser name
  #
  def user_agent=(user_agent)
    @agent.user_agent = user_agent
  end

  # Read PROXY agent attribute
  #
  def proxy
    @agent.proxy
  end

  # Set PROXY agent attribute
  #
  # @param proxy Proxy configuration
  #
  def proxy=(proxy)
    @agent.proxy = proxy
  end

  # Set BASIC_AUTH agent attribute
  #
  # @param username Authentification username
  # @param password Authentification password
  #
  def basic_auth(username, password)
    @agent.basic_auth = { username: username, password: password }
  end

  # Read HEADERS agent attribute
  #
  def headers
    @agent.headers
  end

  # Set HEADERS agent attribute
  #
  # @param headers Request headers
  #
  def headers=(headers)
    @agent.headers = headers
  end

  # Read COOKIES agent attribute
  #
  def cookies
    @agent.cookies
  end

  # Set COOKIES agent attribute
  #
  # @param cookies Request cookies
  #
  def cookies=(cookies)
    @agent.cookies = cookies
  end

  # Call RESET agent method
  #
  def reset
    @agent.reset
  end

  # Set verify_mode
  #
  # @param verify_mode SSL verify mode
  #
  def verify_mode=(verify_mode)
    @agent.verify_mode = verify_mode
  end

  # Set follow_location
  #
  # @param follow_location Follow location flag
  #
  def follow_location=(follow_location)
    @agent.follow_location = follow_location
  end
end
