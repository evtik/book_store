class CreateAuthorsBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :authors_books, id: false do |t|
      t.references :author, foreign_key: true
      t.references :book, foreign_key: true
    end
    add_index :authors_books, [:book_id, :author_id]
  end
end
