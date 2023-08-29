class CreateTraders < ActiveRecord::Migration[7.0]
  def change
    create_table :traders do |t|
      t.string :name
      t.text :stock
      t.text :transaction_history
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
