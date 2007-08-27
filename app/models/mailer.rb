class Mailer < ActionMailer::Base
  default_url_options[:host] = 'audiobank.tryphon.org'

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
  
  def document_shared(user, subscriptions)
    return if subscriptions.empty?
    
    @recipients = user.email
    @from = "AudioBank <audiobank@tryphon.org>"
    @subject = 
      "[AudioBank] " + 
      (subscriptions.size == 1 ? "nouvelle souscription" : "nouvelles souscriptions")
    @body = { :subscriptions => subscriptions, :user => user }
  end
  
end
