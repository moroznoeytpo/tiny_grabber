# Net::HTTP agent for TinyGrabber
# Initialize connect with Resource
# Setting connect attributes
#
class TinyGrabber
  class Agent
    # Debug configuration
    attr_writer :debug
    # Max time to execute request
    attr_writer :read_timeout
    # Web browser name
    attr_writer :user_agent
    # Remote proxy configuration
    attr_accessor :proxy
    # Basic authentification configuration
    attr_writer :basic_auth
    # Headers
    attr_reader :headers
    # Headers
    attr_accessor :cookies
    # Set verify mode
    attr_writer :verify_mode
    # Follow location
    attr_writer :follow_location
    # Uri
    attr_accessor :uri
    # perfect url
    attr_accessor :perfect_url

    #  Agent aliases given from http://www.useragentstring.com/pages/Chrome/
    AGENT_ALIASES = [
      # Chrome
      'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36',
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36',
      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36',
      # Firefox
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1',
      'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10; rv:33.0) Gecko/20100101 Firefox/33.0',
      'Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0',
      # Internet Explorer
      'Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; AS; rv:11.0) like Gecko',
      'Mozilla/5.0 (compatible; MSIE 10.6; Windows NT 6.1; Trident/5.0; InfoPath.2; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 2.0.50727) 3gpp-gba UNTRUSTED/1.0',
      'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 7.0; InfoPath.3; .NET CLR 3.1.40767; Trident/6.0; en-IN)',
      'Mozilla/5.0 (compatible; MSIE 10.0; Macintosh; Intel Mac OS X 10_7_3; Trident/6.0)',
      # Opera
      'Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16',
      'Opera/9.80 (Windows NT 6.0) Presto/2.12.388 Version/12.14',
      'Mozilla/5.0 (Windows NT 6.0; rv:2.0) Gecko/20100101 Firefox/4.0 Opera 12.14',
      'Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; fr) Presto/2.9.168 Version/11.52'
    ].freeze

    # Initialization object
    #
    def initialize
      @debug = Debug.new

      # Initialize variables agent attributes
      @user_agent = AGENT_ALIASES[rand(AGENT_ALIASES.count) - 1]
      @proxy = []
      @basic_auth = {}
      @headers = {}
      @cookies = nil
      @perfect_url = false
      @follow_location = false
      @read_timeout = 10
      # Initialize variable for URI object
      @uri = nil
      # Initialize variable for Net::HTTP request object
      @http = Net::HTTP
      # Initialize variable for Net::HTTP response object
      @response = nil
      @verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    # Set debug configuration
    #
    # @param debug
    #
    def debug=(debug)
      debug = var_to_sym(debug, true)
      if debug.is_a?(Hash)
        @debug.active = debug[:active]
        @debug.destination = debug[:destination]
        @debug.save_html = debug[:save_html]
      elsif debug.is_a?(TrueClass)
        @debug.active = true
      end
    end

    # Set READ_TIMEOUT agent attribute
    #
    # @param read_timeout Waiting time to reading
    #
    def read_timeout=(read_timeout)
      raise 'attribute read_timeout must be Integer' unless read_timeout.is_a?(Integer)
      @read_timeout = read_timeout
    end

    # Set USER_AGENT agent attribute
    #
    # @param user_agent Web browser name
    #
    def user_agent=(user_agent)
      raise 'attribute user_agent must be String' unless user_agent.is_a?(String)
      @user_agent = user_agent
    end

    # Initialize Net::HTTP connection through proxy provider
    # TYPE attribute distribute proxy type on SOCKS4(5) and HTTP(s)
    #
    # @param proxy Proxy configuration
    #
    def proxy=(proxy)
      if proxy.is_a?(String)
        ip, port, type = proxy.split(':')
        raise 'attribute proxy must be in format ip:port' unless ip && port
        type ||= :http
        proxy = { ip: ip, port: port, type: type }
      end
      proxy = var_to_sym(proxy)
      raise 'attribute proxy must be Hash' unless proxy.is_a?(Hash)
      raise 'attribute proxy must contain :ip and :port keys' unless proxy[:ip] && proxy[:port]

      @proxy = proxy
      @http = if [:socks, 'socks'].include? proxy[:type]
                Net::HTTP.SOCKSProxy(proxy[:ip].to_s, proxy[:port].to_s)
              else
                Net::HTTP::Proxy(proxy[:ip], proxy[:port])
              end
    end

    # Set BASIC_AUTH agent attribute
    #
    # @param basic_auth Authentification configuration
    #
    def basic_auth=(basic_auth)
      basic_auth = var_to_sym(basic_auth)
      raise 'attribute basic_auth must be Hash' unless basic_auth.is_a?(Hash)
      raise 'attribute basic_auth must contain :username and :password keys' unless basic_auth[:username] && basic_auth[:password]
      @basic_auth = basic_auth
    end

    # Set HEADERS agent attribute
    #
    # @param headers Request headers
    #
    def headers=(headers)
      raise 'attribute headers must be Hash' unless headers.is_a?(Hash)
      @headers = headers
    end

    # Set COOKIES agent attribute
    #
    # @param cookies Request cookies
    #
    def cookies=(cookies)
      cookies = var_to_sym(cookies)
      cookies = cookies.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join('&') if cookies.is_a?(Hash)
      raise 'attribute cookies must be String' unless cookies.is_a?(String)
      @cookies = cookies
    end

    # Set verify_mode
    #
    # @param verify_mode SSL verify_mode
    #
    # def verify_mode=(verify_mode)
    #   @verify_mode = verify_mode
    # end

    # Init follow location for redirect
    #
    # @param follow_location Follow location flag
    #
    def follow_location=(follow_location)
      raise 'attribute follow_location must be Boolean' unless follow_location.is_a?(TrueClass) || follow_location.is_a?(FalseClass)
      @follow_location = follow_location
    end

    # Fetch request for GET and POST HTTP methods
    # Setting USER_AGENT, BASIC_AUTH, HEADERS, COOKIES request attribute
    # Make response and save COOKIES for next requests
    #
    # @param url Resource link
    # @param method Request method
    # @param headers Request header
    # @param params Request additional params
    #
    def fetch(url, method = :get, headers = {}, params = {})
      if @debug.active
        @debug.save '=============================='
        @debug.save "#{method.upcase} #{url}"
        @debug.save "-> [proxy] = #{@proxy}" if @proxy
        @debug.save "-> [params] = #{params}"
        @debug.save '------------------------------'
      end
      convert_to_uri url
      case method
      when :get
        @request = Net::HTTP::Get.new(@uri.request_uri)
      when :post
        @request = Net::HTTP::Post.new(@uri.request_uri)
        @request.set_form_data(params)
      end
      set_user_agent if @user_agent
      set_basic_auth unless @basic_auth.empty?
      @headers = headers unless headers.empty?
      set_headers if @headers
      set_cookies if @cookies
      @response = send_request
      case @response
      # HTTP response code 1xx
      when Net::HTTPInformation
        @debug.save '<- [response] = Net::HTTPInformation' if @debug.active
      # HTTP response code 2xx
      when Net::HTTPSuccess
        save_headers
        save_cookies
        @debug.save "<- [response] = #{@response.code} Net::HTTPSuccess" if @debug.active
        # Follow meta refresh
        if @follow_location
          refresh = @response.ng.at_css('meta[http-equiv="refresh"]')
          @response = fetch refresh.attr('content').gsub(/\A.*?(http)/, 'http') if refresh
        end
      # HTTP response code 3xx
      when Net::HTTPRedirection
        @debug.save "<- [response] = #{@response.code} Net::HTTPRedirection" if @debug.active
        @debug.save 'try curl user_agent: tg.user_agent=\'curl\'' if @debug.active
        # Follow location
        if @follow_location
          @response = fetch @response.header['Location']
        else
          save_headers
          save_cookies
        end
      # HTTP response code 4xx
      when Net::HTTPClientError
        @debug.save "<- [response] = #{@response.code} Net::HTTPClientError" if @debug.active
      # HTTP response code 5xx
      when Net::HTTPServerError
        @debug.save "<- [response] = #{@response.code} Net::HTTPServerError" if @debug.active
      end
      @response.uri = @uri
      @debug.save_to_file @response.body if @debug.save_html
      @response
    end

    # Initialize URI object from request url
    #
    # @param url Request link
    #
    def convert_to_uri(url)
      unless @perfect_url
        # Remove anchor
        url = url.gsub(/#.*\Z/, '')
        # It's magic work with escaped url
        url = URI.escape(URI.unescape(url))
      end
      @uri = URI(url)
      @debug.save "-> [uri] = #{@uri}" if @debug.active
    end

    # Set USER_AGENT request attribute
    #
    def set_user_agent
      @headers['User-Agent'] = @user_agent
      @debug.save "-> [user_agent] = #{@user_agent}" if @debug.active
    end

    # Set BASIC_AUTH request authentification
    #
    def set_basic_auth
      @request.basic_auth @basic_auth[:username], @basic_auth[:password]
      @debug.save "-> [basic_auth] = #{@basic_auth}" if @debug.active
    end

    # Set request HEADERS
    #
    def set_headers
      @headers.each do |k, v|
        k = String(k)
        case k
        when 'Accept'
          @request[k] = v
        else
          @request.add_field(k, v)
        end
      end
      @debug.save "-> [headers] = #{@headers}" if @debug.active
    end

    # Set request COOKIES
    #
    def set_cookies
      @request['Cookie'] = @cookies
      @debug.save "-> [cookies] = #{@cookies}" if @debug.active
    end

    # Send request and get response
    # Use SSL connect for HTTPS link scheme
    #
    def send_request
      @http.start(@uri.host, @uri.port, use_ssl: @uri.scheme == 'https', verify_mode: @verify_mode, read_timeout: @read_timeout) do |http|
        @debug.save "-> [read_timeout] = #{@read_timeout}" if @debug.active
        http.request(@request)
      end
    end

    # Save response headers in agent attribute
    #
    def save_headers
      return unless @response.header
      @headers = @response.header
      # Delete header TRANSFER_ENCODING for chain of requests
      @headers.delete('transfer-encoding')
      @debug.save "<- [headers] = #{@headers}" if @debug.active
    end

    # Save response cookies in agent attribute
    #
    def save_cookies
      if @response.respond_to?(:cookies)
        return unless @response.cookies
        @cookies = @response.cookies
      else
        return unless @response['Set-Cookie']
        @cookies = @response['Set-Cookie']
      end
    end

    # Clears headers and cookies
    #
    def reset
      @headers = {}
      @cookies = nil
    end

    # Convert variables and contains to symbol
    #
    # @param var Variable need to convert
    #
    def var_to_sym(var, str_to_sym = false)
      if var.is_a?(Hash)
        result = {}
        var.each do |k, v|
          result[k.to_sym] = var_to_sym(v, str_to_sym)
        end
      elsif var.is_a?(Array)
        result = []
        var.each do |v|
          result << var_to_sym(v, str_to_sym)
        end
      elsif var.is_a?(String)
        result = str_to_sym ? var.to_sym : var
      else
        result = var
      end
      result
    end
  end
end
