class Reply < ActiveRecord::Base
  belongs_to :issue
  belongs_to :author, class_name: User

  after_create :update_issue_state, :send_mail

  scope :ordered, -> { order('created_at desc') }

  def from_staff?
    author_id.present?
  end

  def from_client?
    !from_staff?
  end  

  private
  def update_issue_state
    self.author.present? ? self.issue.respond! : self.issue.wait!
  end

  def send_mail
    TicketMailer.delay.message_mail(self.issue)
  end
end
