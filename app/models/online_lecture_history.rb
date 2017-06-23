class OnlineLectureHistory < ApplicationRecord
  attr_accessor :online_provider_id, :online_teacher_id

  scope :original_only, (-> { where(online_lecture_history_id: nil) })
  scope :until, (->(from, to) { where('(completed_at IS NULL AND started_at < ?) OR (completed_at > ? AND started_at < ?)', to, from, to) })

  belongs_to :match
  belongs_to :online_lecture, class_name: 'Standard::OnlineLecture'
  belongs_to :online_lecture_list, class_name: 'Standard::OnlineLectureList', optional: true
  has_one :teacher, class_name: 'Standard::OnlineTeacher', through: :online_lecture

  belongs_to :original_history, class_name: 'OnlineLectureHistory', foreign_key: 'online_lecture_history_id', optional: true
  has_many :details, class_name: 'OnlineLectureHistory', foreign_key: 'online_lecture_history_id'

  validates :planned_at, presence: { if: 'online_lecture_history_id.nil?' }
  validates :online_lecture_id, presence: true, uniqueness: { scope: :match_id, on: :create, if: 'online_lecture_history_id.nil?' }

  around_update :wrap_up_course

  def started_at=(date)
    if date.is_a?(String)
      self[:started_at] =
        if date == 'true'
          Time.zone.now
        elsif date == 'false'
          nil
        else
          Time.zone.parse(date)
        end
    else
      self[:started_at] = super
    end
  end

  def planned_at=(date)
    if date.is_a?(String)
      self[:planned_at] =
        if date == 'true'
          Time.zone.now
        elsif date == 'false'
          nil
        else
          Time.zone.parse(date)
        end
    else
      self[:planned_at] = super
    end
  end

  def completed_at=(date)
    if date.is_a?(String)
      self[:completed_at] =
        if date == 'true'
          Time.zone.now
        elsif date == 'false'
          nil
        else
          Time.zone.parse(date)
        end
    else
      self[:completed_at] = super
    end
  end

  def create_histories(online_lecture_history_params)
    return if online_lecture_id.nil?
    online_lecture = Standard::OnlineLecture.includes(:lists).find(online_lecture_id)
    total_count = online_lecture.lists.size
    online_lecture.lists.each_with_index do |list, index|
      date_offset = ((index + 1) * (planned_at - started_at).to_f / total_count.to_f).ceil
      new_list = details.build(online_lecture_history_params)
      new_list.online_lecture_list_id = list.id
      new_list.started_at = nil
      new_list.planned_at = Time.zone.now + date_offset.day
    end
  end

  def wrap_up_course
    return if online_lecture_history_id.nil?

    if planned_at.nil? && !completed_at.nil?
      self[:completed_at] = nil
    end

    yield

    if original_history.details.where(completed_at: nil).count.zero?
      original_history.update_columns(completed_at: original_history.details.pluck(:completed_at).max)
    else
      original_history.update_columns(completed_at: nil)
    end

    original_history.update_columns(started_at: original_history.details.select{ |d| !d.planned_at.nil? }.pluck(:planned_at).min,
                                    planned_at: original_history.details.select{ |d| !d.planned_at.nil? }.pluck(:planned_at).max)
  end
end
