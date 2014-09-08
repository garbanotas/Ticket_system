class Issue < ActiveRecord::Base

  ACTIONS = %w(respond wait hold complete cancel)
  belongs_to :owner, class_name: User
  has_many :replies, dependent: :destroy

  accepts_nested_attributes_for :replies, allow_destroy: true

  validates :name, :email, :header, presence: true
  validates_associated :replies


  before_create :strip_all, :generate_token

  scope :find,       ->(param) { find_by(token: param) }

  scope :unassigned, -> { where(owner_id: nil) }
  scope :hold,       -> { where(state: 'on_hold') }
  scope :canceled,   -> { where(state: 'canceled') }
  scope :completed,  -> { where(state: 'completed') }



  state_machine :state, initial: :waiting_response do
    state :waiting_response
    state :waiting_customer
    state :on_hold
    state :canceled
    state :closed

    event :respond do
      transition waiting_response: :waiting_customer, on_hold: :waiting_customer
    end

    event :wait do
      transition waiting_response: :waiting_response, waiting_customer: :waiting_response
    end

    event :hold do
      transition waiting_response: :on_hold, waiting_customer: :on_hold
    end

    event :cancel do
      transition waiting_response: :canceled, waiting_customer: :canceled, on_hold: :canceled
    end

    event :activate do
      transition canceled: :waiting_response
    end

    event :complete do
      transition waiting_response: :completed, waiting_customer: :completed, on_hold: :completed
    end
  end

  def to_param
    token
  end

  private

  def strip_all
    self.email = self.email.strip
    self.name = self.name.strip
  end

  def generate_token
    begin
      token = (0..4).map{|x| x.odd? ? (1..9).to_a.sample(3).join : (('A'..'Z').to_a-%w(I O)).sample(3).join }.join('-')
    end while Issue.find_by(token: token).present?
    self.token = token
  end

end
