require "tiny_grabber/version"

require 'uri'
require 'net/http'
require 'socksify'

# Main class for TinyGrabber
class TinyGrabber

  ##
  # Get Net::HTTP object for content from remote single page
  # [url (string)] Link on content
  # [params (hash)] Addition setting
  # * [proxy] Configuration of remote proxy server
  #   * *ip* address of remote proxy server
  #   * *port* of remote proxy server
  #   * *proxy_type* of remote proxy server
  #     * *http* for http(s) proxy servers (by default)
  #     * *socks* for socks4/5 proxy servers
  # * [headers] Headers
  #
  # = Example
  #   TinyGrabber.get url, headers: { 'Content-Type' => 'application/json' }, proxy: { ip: 'xx.xx.xx.xx', port: xx, proxy_type: :socks }
  #
  # @param url Link for content
  # @param params Addition setting
  #
  def self.get url, params = {}
    uri = URI(url)

    params = convert_params_to_sym params

    if params[:proxy]
      # Socks4(5) proxy
      if params[:proxy][:proxy_type] == :socks
        http = Net::HTTP.SOCKSProxy(params[:proxy][:ip], params[:proxy][:port])
        # Http(s) proxy
      else
        http = Net::HTTP::Proxy(params[:proxy][:ip], params[:proxy][:port])
      end
    else
      http = Net::HTTP
    end
    response = http.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri

      # Add headers
      params[:headers].each { |k, v| request.add_field(k, v) } if params[:headers]
      http.request request
    end
    response
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