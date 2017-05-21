class Message < ApplicationRecord
  before_update :update_gmail
  before_destroy :delete_email

  def update_gmail
    email = Gmailer.gmail.inbox.find(:msg_id => self.message_id).first
    return false unless email

    if self.read_changed?
      email.send(self.read ? :read! : :unread!)
    end

    if self.star_changed?
      email.send(self.star ? :star! : :unstar!)
    end
  end

  def delete_email
    email = Gmailer.gmail.inbox.find(:all).find{|d| d.msg_id == self.message_id}
    email && email.delete!
  end

  def self.refresh!
    Gmailer.gmail.inbox.emails(:all).each do |email|
      if message = self.find_by_message_id(email.msg_id)
        Rails.logger.info "Updaing mail with id #{email.msg_id}"
        #TODO: handle failed update
        message.update_columns(label: email.labels.to_s, read: email.read?, star: email.starred?)
      else
        Rails.logger.info "Creating new mail with id #{email.msg_id}"
        self.create(
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
  end
end
