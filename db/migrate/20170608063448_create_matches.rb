class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.references :mentor,         null: false
      t.references :mentee,         null: false

      t.timestamps
    end
  end
end
