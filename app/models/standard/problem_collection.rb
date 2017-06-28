class Standard::ProblemCollection < ApplicationRecord
  belongs_to :subject
  belongs_to :problem_source

  has_many :problem_collection_to_problems
  has_many :problems, through: :problem_collection_to_problems
  accepts_nested_attributes_for :problems

  # has_one :match_history, -> (match_id) { where(match_id: match_id) }, class_name: 'ProblemCollectionHistory', foreign_key: 'problem_collection_id'
end
