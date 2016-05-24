require "tiny_grabber/version"

require 'uri'
require 'net/http'
require 'socksify/http'
require 'tiny_grabber/http'

# Main class for TinyGrabber
class TinyGrabber

  @uri
  @params
  @http
  @request

  ##
  # Get Net::HTTP object for content from remote single page
  # [url (string)] Link to resource
  # [params (hash)] Request params
  # * [proxy (hash)] Configuration of remote proxy server
  #   * *ip* address of remote proxy server
  #   * *port* of remote proxy server
  #   * *proxy_type* of remote proxy server
  #     * *http* for http(s) proxy servers (by default)
  #     * *socks* for socks4/5 proxy servers
  # * [headers (hash)] Headers
  # * [auth (hash)] Basic Authentication
  #   * *username* Authenticate username
  #   * *password* Authenticate password
  #
  # = Example
  #   TinyGrabber.get url, headers: { 'Content-Type' => 'application/json' }, proxy: { ip: 'xx.xx.xx.xx', port: xx, proxy_type: :socks }
  #
  # @param url Link to resource
  # @param params Request params
  #
  def self.get url, params = {}
    @uri = set_url url
    @params = convert_params_to_sym params
    @http = set_http_connect
    @request = Net::HTTP::Get.new(@uri.request_uri)
    set_basic_auth
    set_headers
    get_request
  end


  ##
  # Get Net::HTTP object for content from remote single page
  # [url (string)] Link to resource
  # [data (hash)] Post data
  # [params (hash)] Request params
  # * [proxy (hash)] Configuration of remote proxy server
  #   * *ip* address of remote proxy server
  #   * *port* of remote proxy server
  #   * *proxy_type* of remote proxy server
  #     * *http* for http(s) proxy servers (by default)
  #     * *socks* for socks4/5 proxy servers
  # * [headers (hash)] Headers
  # * [auth (hash)] Basic Authentication
  #   * *username* Authenticate username
  #   * *password* Authenticate password
  #
  # = Example
  #   TinyGrabber.post url, data, headers: { 'Content-Type' => 'application/json' }, proxy: { ip: 'xx.xx.xx.xx', port: xx, proxy_type: :socks }
  #
  # @param url Link to resource
  # @param params Request params
  #
  def self.post url, data, params = {}
    @uri = set_url url
    data = convert_params_to_sym data
    @params = convert_params_to_sym params
    @http = set_http_connect
    @request = Net::HTTP::Post.new(@uri.request_uri)
    @request.set_form_data(data)
    set_basic_auth
    set_headers
    get_request
  end

  private

  # Convert all params key to symbols
  #
  # @param params Request params
  #
  def self.convert_params_to_sym params
    params.is_a?(Hash) ? params.inject({}) { |h, (k, v)| h[k.to_sym] = convert_params_to_sym v; h } : params
  end

  # Convert URL to URI
  #
  # @param url Link to resource
  #
  def self.set_url url
    URI(URI.escape(url))
  end


  # Use proxy for request
  #
  def self.set_http_connect
    if @params[:proxy]
      if ['socks', :socks].include?(@params[:proxy][:proxy_type])
        Net::HTTP.SOCKSProxy(@params[:proxy][:ip], @params[:proxy][:port])
      else
        Net::HTTP::Proxy(@params[:proxy][:ip], @params[:proxy][:port])
      end
    else
      Net::HTTP
    end
  end


  # Set Basic Auth
  #
  # @param request Request object
  # @param params Request params
  #
  def self.set_basic_auth
    if @params[:auth]
      @request.basic_auth @params[:auth][:username], @params[:auth][:password]
    end
  end


  # Headers
  #
  # @param request Request object
  # @param params Request params
  #
  def self.set_headers
    @params[:headers].each { |k, v| @request.add_field(String(k), v) } if @params[:headers]
  end


  # Make request to remote resource
  #
  # @param uri URI object
  # @param http
  #
  def self.get_request
    @http.start(@uri.host, @uri.port, use_ssl: @uri.scheme == 'https') { |http| http.request(@request) }
  end

end