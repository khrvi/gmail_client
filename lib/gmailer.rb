module Gmailer
  def gmail
    begin
      return @gmail if @gmail && @gmail.inbox
    rescue
      puts "Session expired! Reconnecting ..."
    end
    @gmail = Gmail.connect!(GMAIL_USER_NAME, GMAIL_USER_PASSWORD)
  end

  module_function :gmail
end