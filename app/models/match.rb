class Match < ApplicationRecord
  belongs_to :mentor
  belongs_to :mentee
  has_many :mentor_users, through: :mentor, source: :user
  has_many :mentee_users, through: :mentee, source: :user
  has_many :schedules, dependent: :destroy
  accepts_nested_attributes_for :schedules, allow_destroy: true

  has_many :online_lecture_histories, dependent: :destroy
end
