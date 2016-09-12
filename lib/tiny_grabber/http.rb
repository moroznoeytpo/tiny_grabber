require 'nokogiri'

# Net/HTTP module
module Net
  # Success response class
  class HTTPOK
    # Nokogiri object of response
    #
    def ng
      Nokogiri::HTML(body)
    end

    # Response Cookies
    #
    def cookies
      cookies = get_fields('set-cookie')
      if cookies
        cookies.map { |cookie| cookie.gsub(/\A([^;]+).*\Z/, '\1') }.join('&')
      end
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
