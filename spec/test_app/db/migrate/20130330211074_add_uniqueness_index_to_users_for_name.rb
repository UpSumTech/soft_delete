class AddUniquenessIndexToUsersForName < ActiveRecord::Migration
  def change
    add_index :users, ['name'], :name => 'index_user_names', :unique => true
  end
end
