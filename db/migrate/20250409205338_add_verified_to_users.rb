class AddVerifiedToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :verified, :boolean
  end
end
