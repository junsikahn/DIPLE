class ProblemCollectionHistory < ApplicationRecord
  scope :until, (->(start_date, end_date) { where('(completed_at IS NULL AND planned_at < ?) OR (planned_at > ? AND planned_at < ?)', end_date, start_date, end_date) })

  belongs_to :match
  belongs_to :problem_collection, class_name: 'Standard::ProblemCollection'

  has_many :problem_histories, dependent: :destroy
  accepts_nested_attributes_for :problem_histories

  before_update :scoring

  def build_problems
    problem_collection.problems.each do |problem|
      problem_histories.build(match_id: match_id, subject_id: problem.subject_id, problem_collection_id: problem_collection.id, problem_id: problem.id)
    end
  end

  def scoring
    self[:score] = 0
    problem_histories.each do |problem_history|
      next unless problem_history.correct?
      problem_history.problem.correct_count += 1
      self[:score] += problem_history.problem.score
      problem_history.problem.save
    end
  end
end
