class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.string :nickname
      t.string :email
      t.boolean :approved
      t.timestamps
    end
  end
end
