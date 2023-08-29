class CreateTransactionHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_histories do |t|
      t.text :trader_info
      t.text :stock_info
      t.references :trader  ,foreign_key: true


      t.timestamps
    end
  end
end
