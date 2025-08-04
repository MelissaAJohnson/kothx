class Team < ApplicationRecord
  belongs_to :user
  has_many :picks, dependent: :destroy
  validates :name, presence: true, uniqueness: {case_sensitive: false, message: "has already been taken. Please use a different name."}

  # after_create :send_new_team_email

  private
    def send_new_team_email
    TeamMailer.new_team(self).deliver_now
    end
end
