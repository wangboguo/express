# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview

  def subscription
    @email = SubscriptionMailer.subscription("nkj20932@hotmail.com",[Post.last, Post.first])
  end
end
