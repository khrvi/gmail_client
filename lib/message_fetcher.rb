require 'gmail'
require 'sidekiq-scheduler'

class MessageFetcher
  include Sidekiq::Worker

  def perform
    # set creds through env variables
    Gmail.connect(ENV['GMAIL_USER_NAME'], ENV['GMAIL_USER_PASSWORD']) do |gmail|
      if gmail.logged_in?
        gmail.inbox.emails(:all).each do |email|
          # put a couple attrs to DB for now
          Message.create(message_id: email.msg_id, body: email.message, label: email.labels)
        end
      else
        puts "Login failed."
      end
    end
  end
end