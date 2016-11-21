class CreateKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :keys do |t|
      t.text :token
      t.integer :status, default: 0, null: false
      t.datetime :created_at
      t.datetime :assigned_at
      t.datetime :released_at
      t.datetime :deleted_at
      t.datetime :renewed_at
      t.integer :renewal_status, default: 1, null: false
    end

    add_index :keys, :token, unique: true, name: 'UNIQUE_TOKEN_INDEX_ON_KEYS'
    add_index :keys, [:token, :status], name: 'TOKEN_WITH_STATUS_INDEX'
  end
end
