# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base
  default :from => "AudioBank <audiobank@tryphon.eu>"

  def confirm(user, controller)
    @user = user
    @controller = controller

    mail :to => user.email, :subject => "[AudioBank] Bienvenue !"
  end

  def new_password(user, new_password)
    @new_password = new_password
    @user = user

    mail :to => user.email, :subject => "[AudioBank] Votre mot de passe"
  end

  def document_ready(document)
    @document = document
    @user = document.author

    mail :to => document.author.email, :subject => "[AudioBank] #{document.title} prêt"
  end

  def document_shared(user, subscriptions)
    return if subscriptions.empty?

    @subscriptions = subscriptions
    @user = user

    subject =
      "[AudioBank] " +
      (subscriptions.size == 1 ? "nouvelle souscription" : "nouvelles souscriptions")

    mail :to => user.email, :subject => subject
  end

end
