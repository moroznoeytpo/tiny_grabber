# Net::HTTP agent for TinyGrabber
# Initialize connect with Resource
# Setting connect attributes
#
class TinyGrabber::Agent
  # Debug flag for detilazition log and save result HTML to /log/*.html file
  attr_accessor :debug
  # Max time to execute request
  attr_accessor :read_timeout
  # Web browser name
  attr_accessor :user_agent
  # Remote proxy configuration
  attr_accessor :proxy
  # Basic authentification configuration
  attr_accessor :basic_auth
  # Headers
  attr_accessor :headers
  # Headers
  attr_accessor :cookies

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
    'Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; fr) Presto/2.9.168 Version/11.52',
  ]

  # Initialization object
  #
  def initialize
    @debug = false

    # Initialize variables agent attributes
    @user_agent = AGENT_ALIASES[rand(AGENT_ALIASES.count) - 1]
    @proxy = []
    @basic_auth = {}
    @headers = {}
    @cookies = nil
    @read_timeout = 10
    # Initialize variable for URI object
    @uri = nil
    # Initialize variable for Net::HTTP request object
    @http = Net::HTTP
    # Initialize variable for Net::HTTP response object
    @response = nil
  end


  # Set READ_TIMEOUT agent attribute
  #
  # @param read_timeout Waiting time to reading
  #
  def read_timeout= read_timeout
    fail 'attribute read_timeout must be Integer' unless read_timeout.is_a?(Integer)
    @read_timeout = read_timeout
  end


  # Set USER_AGENT agent attribute
  #
  # @param user_agent Web browser name
  #
  def user_agent= user_agent
    fail 'attribute user_agent must be String' unless user_agent.is_a?(String)
    @user_agent = user_agent
  end


  # Initialize Net::HTTP connection through proxy provider
  # TYPE attribute distribute proxy type on SOCKS4(5) and HTTP(s)
  #
  # @param proxy Proxy configuration
  #
  def proxy= proxy
    if proxy.is_a?(String)
      ip, port = proxy.split(':')
      fail 'attribute proxy must be in format ip:port' unless ip and port
      proxy = { ip: ip, port: port }
    end
    fail 'attribute proxy must be Hash' unless proxy.is_a?(Hash)
    fail 'attribute proxy must contain :ip and :port keys' unless proxy[:ip] and proxy[:port]

    @proxy = proxy
    if ['socks', :socks].include?(proxy[:type])
      @http = Net::HTTP.SOCKSProxy(proxy[:ip], proxy[:port])
    else
      @http = Net::HTTP::Proxy(proxy[:ip], proxy[:port])
    end
  end


  # Set BASIC_AUTH agent attribute
  #
  # @param basic_auth Authentification configuration
  #
  def basic_auth= basic_auth
    fail 'attribute basic_auth must be Hash' unless basic_auth.is_a?(Hash)
    fail 'attribute basic_auth must contain :username and :password keys' unless basic_auth[:username] and basic_auth[:password]
    @basic_auth = basic_auth
  end


  # Set HEADERS agent attribute
  #
  # @param headers Request headers
  #
  def headers= headers
    fail 'attribute headers must be Hash' unless headers.is_a?(Hash)
    @headers = headers
  end


  # Set COOKIES agent attribute
  #
  # @param cookies Request cookies
  #
  def cookies= cookies
    fail 'attribute cookies must be String' unless cookies.is_a?(String)
    @cookies = cookies
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
  def fetch url, method = :get, headers = {}, params = {}
    if @debug
      p "#{debug_initial_word} =============================="
      p "#{debug_initial_word} #{method.upcase} #{url}"
      p "#{debug_initial_word} -> [params] = #{params}"
      p "#{debug_initial_word} ------------------------------"
    end
    set_uri url
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
    set_headers unless @headers.empty?
    set_cookies if @cookies
    @response = send_request
    case @response
      # HTTP response code 1xx
      when Net::HTTPInformation
      # HTTP response code 2xx
      when Net::HTTPSuccess
        save_headers if @response.header
        save_cookies if @response.cookies
      # HTTP response code 3xx
      when Net::HTTPRedirection
      # HTTP response code 4xx
      when Net::HTTPClientError
      # HTTP response code 5xx
      when Net::HTTPServerError
    end
    if @debug
      debug_filename = "log/#{method.upcase}_#{@uri.to_s.gsub(/[\/:]/, '_').gsub(/_+/, '_')}"
      File.open(debug_filename, 'wb') { |f| f << @response.body } if @debug
      p "#{debug_initial_word} <- [html_file] = #{debug_filename}"
    end
    @response
  end


  # Initialize URI object from request url
  #
  # @param url Request link
  #
  def set_uri url
    # It's magic work with escaped url
    @uri = URI(URI.escape(URI.unescape(url)))
    p "#{debug_initial_word} -> [uri] = #{@uri}" if @debug
  end


  # Set USER_AGENT request attribute
  #
  def set_user_agent
    @headers['User-Agent'] = @user_agent
    p "#{debug_initial_word} -> [user_agent] = #{@user_agent}" if @debug
  end


  # Set BASIC_AUTH request authentification
  #
  def set_basic_auth
    @request.basic_auth @basic_auth[:username], @basic_auth[:password]
    p "#{debug_initial_word} -> [basic_auth] = #{@basic_auth}" if @debug
  end


  # Set request HEADERS
  #
  def set_headers
    @headers.each { |k, v| @request.add_field(String(k), v) }
    p "#{debug_initial_word} -> [headers] = #{@headers}" if @debug
  end


  # Set request COOKIES
  #
  def set_cookies
    @request['Cookie'] = @cookies
    p "#{debug_initial_word} -> [cookies] = #{@cookies}" if @debug
  end


  # Send request and get response
  # Use SSL connect for HTTPS link scheme
  #
  def send_request
    @http.start(@uri.host, @uri.port, use_ssl: @uri.scheme == 'https') do |http|
      http.read_timeout = @read_timeout
      p "#{debug_initial_word} -> [read_timeout] = #{@read_timeout}" if @debug
      http.request(@request)
    end
  end


  # Save response headers in agent attribute
  #
  def save_headers
    @headers = @response.headers
    # Delete header TRANSFER_ENCODING for chain of requests
    @headers.delete('transfer-encoding')
    p "#{debug_initial_word} <- [headers] = #{@headers}" if @debug
  end


  # Save response cookies in agent attribute
  #
  def save_cookies
    @cookies = @response.cookies
    p "#{debug_initial_word} <- [cookies] = #{@cookies}" if @debug
  end


  # Clears headers and cookies
  #
  def reset
    @headers = {}
    @cookies = nil
  end


  # Tiny grabber initial word for debug
  #
  def debug_initial_word
    "TG | #{Time.now.strftime('%Y%m%d-%H%M%S')} |"
  end
end