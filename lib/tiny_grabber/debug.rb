# Save debug log information
class Debug

  # Save log information
  #
  # @param destination Save log to file or print
  # @param message Message body
  #
  def self.save destination = :print, message
    message = "TG | #{Time.now.strftime('%Y%m%d-%H%M%S')} | #{message}"
    case destination
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
  def self.save_to_file message
    debug_path = "#{Dir.pwd}/log"
    Dir.mkdir(debug_path, 0775) unless File.exists? debug_path
    filename = "#{Time.now.strftime('%Y%m%d')}.log"
    File.open("#{debug_path}/#{filename}", 'a+') { |f| f << "#{message}\r\n" }
  end
end