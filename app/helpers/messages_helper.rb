module MessagesHelper
	def print_bold_if_unread(message, field)
		value = message.send(field)
		raw message.read ? value : "<b>#{value}</b>"
	end
end
