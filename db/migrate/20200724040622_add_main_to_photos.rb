class AddMainToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :main, :boolean, default: false
  end
end
