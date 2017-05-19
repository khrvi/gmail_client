class Message < ApplicationRecord
  before_update :update_gmail
  before_destroy :delete_email

  def update_gmail
    Gmail.connect!(GMAIL_USER_NAME, GMAIL_USER_PASSWORD) do |gmail|
      email = gmail.inbox.find(:msg_id => self.message_id).first
      return false unless email

      if self.read_changed?
        email.send(self.read ? :read! : :unread!)
      end

      if self.star_changed?
        email.send(self.star ? :star! : :unstar!)
      end
    end
  end

  def delete_email
    Gmail.connect!(GMAIL_USER_NAME, GMAIL_USER_PASSWORD) do |gmail|
      email = gmail.inbox.find(:msg_id => self.message_id).first
      email && email.delete!
    end
  end
end
