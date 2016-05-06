require "tiny_grabber/version"

require 'uri'
require 'net/http'
require 'socksify/http'
require 'tiny_grabber/http'

# Main class for TinyGrabber
class TinyGrabber

  ##
  # Get Net::HTTP object for content from remote single page
  # [url (string)] Link on content
  # [params (hash)] Addition setting
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
  # * [post (hash)] POST data
  #
  # = Example
  #   TinyGrabber.get url, headers: { 'Content-Type' => 'application/json' }, proxy: { ip: 'xx.xx.xx.xx', port: xx, proxy_type: :socks }
  #
  # @param url Link for content
  # @param params Addition setting
  #
  def self.get url, params = {}
    uri = URI(URI.escape(url))

    params = convert_params_to_sym params

    # Use proxy for request
    if params[:proxy]
      if ['socks', :socks].include?(params[:proxy][:proxy_type])
        http = Net::HTTP.SOCKSProxy(params[:proxy][:ip], params[:proxy][:port])
      else
        http = Net::HTTP::Proxy(params[:proxy][:ip], params[:proxy][:port])
      end
    else
      http = Net::HTTP
    end

    # Set HTTP request type
    if params[:post] or params.key?(:post)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(params[:post])
    else
      request = Net::HTTP::Get.new(uri.request_uri)
    end

    # Set Basic Auth
    if params[:auth]
      request.basic_auth params[:auth][:username], params[:auth][:password]
    end

    # Set headers
    params[:headers].each { |k, v| request.add_field(String(k), v) } if params[:headers]

    # Get response
    http.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
  end

  private

  # Convert all params key to symbols
  #
  # @param params Hash
  #
  def self.convert_params_to_sym params
    params = params.inject({}) { |h, (k, v)| h[k.to_sym] = convert_params_to_sym v; h } if params.is_a?(Hash)
    params
  end
end