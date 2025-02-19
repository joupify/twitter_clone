class AddMetadataToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :metadata, :json
  end
end
