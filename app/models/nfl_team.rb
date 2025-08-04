class NflTeam < ApplicationRecord
  validates :city, presence: true
  validates :name, presence: true
end
