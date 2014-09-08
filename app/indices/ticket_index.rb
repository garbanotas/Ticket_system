ThinkingSphinx::Index.define :ticket, with: :active_record do
  indexes subject
  indexes token
  indexes messages.body, as: :messages
  has :email, :created_at, :owner_id
end
