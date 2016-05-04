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
  end
end