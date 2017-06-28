class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problem_sources do |t|
      t.string     :name,            null: false, unique: true
    end
    sources = %w(일일테스트 수능 모의고사)
    sources.each do |s|
      Standard::ProblemSource.create(name: s)
    end

    create_table :problem_collections do |t|
      t.references :subject,         null: false
      t.references :problem_source,  null: false
      t.string     :name,            null: false
      t.integer    :total_score
      t.date       :test_day
      t.timestamps
    end

    create_table :problems do |t|
      t.references :subject,  null: false
      t.integer    :level
      t.attachment :image
      t.integer    :answer
      t.attachment :answer_image
      t.integer    :score,          default: 1
      t.integer    :total_count,    default: 0
      t.integer    :correct_count,  default: 0
      t.references :problem
      t.attachment :audio
      t.string     :problem_hwp
      t.timestamps
    end

    create_table :problem_collection_to_problems do |t|
      t.references :problem_collection,  null: false
      t.references :problem,             null: false
      t.integer    :order
    end
  end
end
