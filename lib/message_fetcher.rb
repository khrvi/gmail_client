require 'gmail'
require 'sidekiq-scheduler'

class MessageFetcher
  include Sidekiq::Worker

  def perform
    # set creds through env variables
    Gmail.connect(ENV['GMAIL_USER_NAME'], ENV['GMAIL_USER_PASSWORD']) do |gmail|
      if gmail.logged_in?
        gmail.inbox.emails(:all).each do |email|
          next if Message.find_by_message_id(email.msg_id)
          Message.create(
            message_id: email.msg_id,
            body: email.message.body,
            label: email.labels.to_s,
            to: email.message.to,
            from: email.message.from,
            subject: email.message.subject
          )
        end
      else
        puts "Login failed."
      end
    end
  end
end