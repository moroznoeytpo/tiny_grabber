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


  # Set debug active flag
  #
  # @param active Flag
  #
  def active= active
    @active = active
  end


  # Get debug active flag
  def active
    @active
  end


  # Set debug destination
  #
  # @param destination Save log to file or print
  #
  def destination= destination
    @destination = destination
  end


  # Get debug destination
  #
  def destination
    @destination
  end


  # Set debug flag to save response HTML to file
  #
  # @param save_html Flag
  def save_html= save_html
    @save_html = save_html
  end


  # Get debug flag to save response HTML to file
  #
  def save_html
    @save_html
  end


  # Save log information
  #
  # @param message Message body
  #
  def save message
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
  def save_to_file message
    debug_path = "#{Dir.pwd}/log"
    Dir.mkdir(debug_path, 0775) unless File.exists? debug_path
    filename = "#{Time.now.strftime('%Y%m%d')}.log"
    File.open("#{debug_path}/#{filename}", 'a+') { |f| f << "#{message}\r\n" }
  end
end