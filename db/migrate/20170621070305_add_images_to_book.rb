class AddImagesToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :images, :string, array: true, default: []
  end
end
