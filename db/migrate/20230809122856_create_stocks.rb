class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :name 
      t.string :currency
      t.decimal :amount
   
      t.string :symbol
     
      t.decimal :asset
      t.references :trader , foreign_key: true


      t.timestamps
    end
  end
end
