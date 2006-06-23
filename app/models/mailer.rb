class Mailer < ActionMailer::Base
  def confirm(user, controller)
    @recipients = user.email
    @from = "AudioBank <audiobank@tryphon.org>"
    @subject = "[AudioBank] Bienvenue !"
    @body = { :controller => controller }
    @body["user"] = user
  end
end
