require 'nokogiri'

# Net/HTTP module
module Net
  # Success response class
  class HTTPOK

    # Nokogiri object of response
    #
    def ng
      Nokogiri::HTML(self.body)
    end

    # Response Cookies
    #
    def cookies
      cookies = self.get_fields('set-cookie')
      if cookies
        cookies.map { |cookie| cookie.gsub(/\A([^;]+).*\Z/, '\1') }.join('&')
      else
        nil
      end
    end


    # Response Headers
    #
    def headers
      self.header.to_hash.inject({}) { |headers, (header_key, header_value)| headers[header_key] = header_value.first; headers }
    end
  end
end