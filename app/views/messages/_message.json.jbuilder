json.extract! message, :id, :message_id, :from, :to, :subject, :label, :body, :created_at, :updated_at
json.url message_url(message, format: :json)
