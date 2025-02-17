class AddBannerToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :banner, :string
  end
end
