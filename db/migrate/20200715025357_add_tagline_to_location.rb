class AddTaglineToLocation < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :tagline, :string
    change_column :locations, :description, :text
  end
end
