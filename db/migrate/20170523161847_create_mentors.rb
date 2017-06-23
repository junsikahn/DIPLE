class CreateMentors < ActiveRecord::Migration[5.0]
  def change
    create_table :mentors do |t|
      t.references :user, null: false

      t.text     :self_introduction, default: ''
      t.string   :bank_name
      t.string   :account_number

      t.datetime :recruited_at
      t.datetime :interviewed_at
      t.datetime :authorized_at

      t.timestamps
    end
  end
end
