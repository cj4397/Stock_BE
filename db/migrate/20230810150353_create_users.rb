class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_hash
      t.string :token
    
      t.text :trader
      t.boolean :is_admin
      t.boolean :is_trader



      t.timestamps
    end
  end
end
