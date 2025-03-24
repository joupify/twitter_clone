class AddParentIdToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :parent_id, :bigint
  end
end
