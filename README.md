# Gmail client

This application is a simple gmail client that based on 'gmail' and 'mail' gems. The main goal is to provide a simple interface for managing 'Inbox' of users gmail account.
The app supports only one gmail account configured through env variables GMAIL_USER_NAME and GMAIL_USER_PASSWORD. For now supported only basic authentication so that make sure your gmail account configured properly.
For peridic pulling incoming email of your gmail account is used periodic jobs based on Sidekiq lib. Sidekiq configuration could be found in the 'config/sidekiq.yml'. By default we pull messages once in a minute.
The main landing page shows all messages in user's Inbox. 'Bold' font means 'unread' message, regular font means 'read' messages. User is able to see details of particular image on show page. Moreover he is able to manage message by doing: 'Delete', 'Mark as start' / 'Unstar', 'Mark as read' / 'Unread'. In addition user is able to quick reply on current message. Attachments are presented by printing filenames in the certain section on show page of Inbox message.
