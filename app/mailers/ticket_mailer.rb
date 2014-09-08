class TicketMailer < ActionMailer::Base
  default from: "from@example.com"

  def message_mail(issue)
    @issue = issue
    mail(to: @issue.email, subject: "#{@issue.replies.last.from_client? ? 'RE: ' : ''}Your Support Issue: #{@issue.header}") do |format|
      format.html { render layout: 'mailer' }
      format.text
    end
  end
end
