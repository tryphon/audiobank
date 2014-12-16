class ChangeDocumentDescriptionIntoText < ActiveRecord::Migration
  def up
    change_column :documents, :description, :text
  end
  def down
    change_column :documents, :description, :string
  end
end
