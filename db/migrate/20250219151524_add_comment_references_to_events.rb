class AddCommentReferencesToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :comment, null: true, foreign_key: true
  end
end
