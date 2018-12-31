class CreateFighters < ActiveRecord::Migration[5.2]
  def change
    create_table :fighters do |t|
      t.string :first_name
      t.string :last_name
      t.string :alias
      t.string :team
      t.string :url_photo

      t.timestamps
    end
  end
end
