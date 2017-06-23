class AddImagesToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :main_image, :json
    add_column :books, :images, :json
  end
end
