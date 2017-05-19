require 'sidekiq-scheduler'

class MessageFetcher
  include Sidekiq::Worker

  def perform
    # set creds through env variables
    Gmail.connect(ENV['GMAIL_USER_NAME'], ENV['GMAIL_USER_PASSWORD']) do |gmail|
      if gmail.logged_in?
        gmail.inbox.emails(:all).each do |email|
          if message = Message.find_by_message_id(email.msg_id)
            #TODO: handle failed update
            message.update_columns(label: email.labels.to_s, read: email.read?, star: email.starred?)
          else
            Message.create(
              message_id: email.msg_id,
              body: email.message.body,
              label: email.labels.to_s,
              to: email.message.to,
              from: email.message.from,
              subject: email.message.subject,
              date: email.date,
              read: email.read?,
              star: email.starred?
            )
          end
        end
      else
        puts "Login failed."
      end
    end
  end
end