class Mailer < ActionMailer::Base
  def confirm(user, controller)
    @recipients = user.email
    @from = "AudioBank <audiobank@tryphon.org>"
    @subject = "[AudioBank] Bienvenue !"
    @body = { :controller => controller }
    @body["user"] = user
  end
  
  def document_ready(document)
    @recipients = document.author.email
    @from = "AudioBank <audiobank@tryphon.org>"
    @subject = "[AudioBank] #{document.title} prêt"
    @body = { :document => document, :user => document.author }
  end
  
end
