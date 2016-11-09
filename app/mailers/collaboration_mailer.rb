class CollaborationMailer < ApplicationMailer
  def invite(collaboration)
    @collaboration = collaboration

    mail to: @collaboration.invite_email,
         subject: %(You are invited to collaborate on "#{@collaboration.share}")
  end

  def notify(collaboration)
    @collaboration = collaboration

    mail to: @collaboration.user.email,
         subject: %(You are invited to collaborate on "#{@collaboration.share}")
  end
end