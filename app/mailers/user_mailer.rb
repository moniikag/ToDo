class UserMailer < ApplicationMailer

  def reminder(urgent_items, user)
    @urgent_items = urgent_items
    @user = user
    mail(to: @user.email, subject: 'Reminder from Todo List')
  end

  def registration_confirmation(user)
    @user = user
    mail(to: @user.email, subject: "Registration Confirmation")
  end

  def invitation(invitation)
    @invitation = invitation
    mail(to: 'monikaglier@gmail.com', subject: "Invitation to Todo List")
  end

end

