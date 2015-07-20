class UserMailer < ApplicationMailer
  def send_welcome_email( user )

    mail(
      to: user.email,
      subject: "Welcome to LiveJudging!",
      body: "You've been added as a judge to LiveJudging.com. Your temporary password is '#{user.password}'"
    )
  end
end
