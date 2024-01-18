class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.date :upload_date

      t.timestamps
    end
  end
end
