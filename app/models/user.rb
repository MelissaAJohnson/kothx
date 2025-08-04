class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :teams

  before_save { self.role ||= :member }
  # after_create :send_user_email

  enum role: [:member, :manager, :admin]

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def send_user_email
    UserMailer.new_user(self).deliver_now
  end
end
