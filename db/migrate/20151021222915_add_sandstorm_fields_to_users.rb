class AddSandstormFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sandstorm_user_id, :string
    add_column :users, :sandstorm_avatar_url, :string
    add_index :users, :sandstorm_user_id
  end
end
