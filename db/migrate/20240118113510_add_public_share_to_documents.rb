class AddPublicShareToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :public_share, :boolean
  end
end
