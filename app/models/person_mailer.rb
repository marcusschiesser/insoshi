class PersonMailer < ActionMailer::Base
  extend PreferencesHelper
  
  def domain
    @domain ||= PersonMailer.global_prefs.domain
  end
  
  def server
    @server_name ||= PersonMailer.global_prefs.server_name
  end
  
  def password_reminder(person)
    from         _("Password reminder <password-reminder@%{domain}>") % {:domain => domain}
    recipients   person.email
    subject      formatted_subject(_("Password reminder"))
    body         "domain" => server, "person" => person
  end
  
  def message_notification(message)
    from         _("Message notification <message@%{domain}>") % {:domain => domain}
    recipients   message.recipient.email
    subject      formatted_subject(_("New message"))
    body         "domain" => server, "message" => message,
                 "preferences_note" => preferences_note(message.recipient)
  end
  
  def connection_request(connection)
    from         _("Contact request <connection@%{domain}>") % {:domain => domain}
    recipients   connection.person.email
    subject      formatted_subject(_("New contact request"))
    body         "domain" => server,
                 "connection" => connection,
                 "url" => edit_connection_path(connection),
                 "preferences_note" => preferences_note(connection.person)
  end
  
  def blog_comment_notification(comment)
    from         _("Comment notification <comment@%{domain}>") % {:domain => domain}
    recipients   comment.commented_person.email
    subject      formatted_subject(_("New blog comment"))
    body         "domain" => server, "comment" => comment,
                 "url" => 
                 blog_post_path(comment.commentable.blog, comment.commentable),
                 "preferences_note" => 
                    preferences_note(comment.commented_person)
  end
  
  def wall_comment_notification(comment)
    from         _("Comment notification <comment@%{domain}>") % {:domain => domain}
    recipients   comment.commented_person.email
    subject      formatted_subject(_("New wall comment"))
    body         "domain" => server, "comment" => comment,
                 "url" => person_path(comment.commentable, :anchor => "wall"),
                 "preferences_note" => 
                    preferences_note(comment.commented_person)
  end
  
  def email_verification(ev)
    from         _("Email verification <email@%{domain}>") % {:domain => domain}
    recipients   ev.person.email
    subject      formatted_subject(_("Email verification"))
    body         "server_name" => server,
                 "code" => ev.code
  end
  
  private
  
    # Prepend the application name to subjects if present in preferences.
    def formatted_subject(text)
      name = PersonMailer.global_prefs.app_name
      label = name.blank? ? "" : "[#{name}] "
      "#{label}#{text}"
    end
  
    def preferences_note(person)
      %(To change your email notification preferences, visit
      
http://#{server}/people/#{person.to_param}/edit)
    end
end
