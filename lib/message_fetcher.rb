require 'sidekiq-scheduler'

class MessageFetcher
  include Sidekiq::Worker

  def perform
    if Gmailer.gmail.logged_in?
      Message.refresh!
    else
      puts "Login failed."
    end
  end
end