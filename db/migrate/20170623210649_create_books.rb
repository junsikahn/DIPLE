class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.references :subject,         null: false
      t.string     :name
      t.integer    :total_page
      t.string     :series
      t.string     :publisher
      t.date       :published_at
    end

    create_table :book_units do |t|
      t.references :subject,         null: false
      t.references :book,            null: false
      t.string     :name
      t.integer    :page
      t.integer    :order
      t.integer    :depth
    end
  end
end
