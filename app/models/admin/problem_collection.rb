class Admin::ProblemCollection < Standard::ProblemCollection
  validate :scoring

  def scoring
    self[:total_score] = problems.map(&:score).sum
  end
end
