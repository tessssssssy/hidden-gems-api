class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :body
      t.references :user, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.references :thread
      t.timestamps
    end
  end
end
