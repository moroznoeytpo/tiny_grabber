require 'nokogiri'
require 'nokogumbo'

# Net/HTTP module
module Net
  # Success response class
  class HTTPOK
    # Nokogiri object of response
    #
    def ng(html_version = 4)
      if html_version == 5
        Nokogiri::HTML5(body)
      else
        body.encoding.to_s != 'UTF-8' ? Nokogiri::HTML(body, 'UTF-8') : Nokogiri::HTML(body)
      end
    end

    # Response Cookies
    #
    def cookies
      cookies = get_fields('set-cookie')
      cookies.map { |cookie| cookie.gsub(/\A([^;]+).*\Z/, '\1') }.join('&') if cookies
    end

    # Response Headers
    #
    def headers
      header.to_hash.each_with_object({}) do |header_key, header_value|
        header_value[header_key] = header_value.first
      end
    end
  end
end
