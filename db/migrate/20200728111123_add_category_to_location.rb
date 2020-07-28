class AddCategoryToLocation < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :category, :string
  end
end
