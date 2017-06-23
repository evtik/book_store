class AddMainImageToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :main_image, :json
  end
end
