class Member < ActiveRecord::Base
  belongs_to :meetup
  belongs_to :user
  validates :meetup, presence: true
  validates :user, presence: true
  validates_uniqueness_of :meetup_id, scope: :user_id
=begin
  def already_joined?
    binding.pry
    validates_uniqueness_of :meetup_id, scope: :user_id
  end
=end
end
