class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :amount, :null => false
      t.references :receiver, index: true, foreign_key: {to_table: :users}, :null => false
      t.references :sender, index: true, foreign_key: {to_table: :users}, :null => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
