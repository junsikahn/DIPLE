class Standard::Problem < ApplicationRecord
  belongs_to :subject
  has_many :problem_collection_to_problems
  has_many :problem_collections, through: :problem_collection_to_problems

  belongs_to :original_problem, class_name: 'Standard::Problem', foreign_key: 'problem_id', optional: true
  has_many :related_problems, class_name: 'Standard::Problem', foreign_key: 'problem_id'

  has_attached_file :image, default_url: '/images/image_preview.png'
  has_attached_file :answer_image, default_url: '/images/image_preview.png'
  has_attached_file :audio, default_url: '/moon.mp3'
end
