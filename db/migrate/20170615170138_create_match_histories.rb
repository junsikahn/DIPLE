class CreateMatchHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :online_lecture_histories do |t|
      t.references :match,               null: false
      t.references :online_lecture,      null: false
      t.references :online_lecture_list
      t.date       :started_at
      t.date       :planned_at
      t.date       :completed_at
      t.references :online_lecture_history
      t.timestamps
    end

    create_table :comments do |t|
      t.references :match,               null: false
      t.references :user,                null: false
      t.references :subject,             null: false
      t.text       :content
      t.date       :completed_at
      t.references :comment
      t.timestamps
    end
  end
end
