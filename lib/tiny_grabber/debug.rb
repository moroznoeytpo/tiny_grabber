# Save debug log information
class Debug
  # Flag to active debug save log
  attr_accessor :active
  # Print log or save to file
  attr_accessor :destination
  # Flag to save response HTML to file
  attr_accessor :save_html

  # Initialize a debug object
  #
  def initialize
    @active = false
    @destination = :print
    @save_html = false
  end

  # Save log information
  #
  # @param message Message body
  #
  def save(message)
    message = "TG | #{Time.now.strftime('%Y%m%d-%H%M%S')} | #{message}"
    case @destination
    when :file
      save_to_file message
    when :print
      p message
    end
  end

  # Save log information to file
  #
  # @param message Message body
  #
  def save_to_file(message)
    # Encode message for correct Unix encoding
    message = message.force_encoding('utf-8')
    debug_path = "#{Dir.pwd}/log"
    Dir.mkdir(debug_path, 0o775) unless File.exist? debug_path
    filename = "#{Time.now.strftime('%Y%m%d')}.log"
    File.open("#{debug_path}/#{filename}", 'a+') { |f| f << "#{message}\r\n" }
  end
end
