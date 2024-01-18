class AddTokenToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :uuid, :string
    add_index :documents, :uuid, unique: true
  end
end
