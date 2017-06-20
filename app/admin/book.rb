ActiveAdmin.register Book do
  # permit_params :title, :description, :year, :height, :width, :thickness,
                # :price

  batch_action :destroy do |ids|
    batch_action_collection.find(ids).each do |book|
      book.destroy
    end
    redirect_to collection_path, notice: 'Deleted!'
  end

  index do
    selectable_column
    column 'Image' do |book|
      image_tag(book_image_path(book.images.first.path), width: 45, height: 67)
    end
    column(:category) { |book| book.category.name.capitalize }
    column :title
    column('Authors') { |book| book.decorate.authors_short }
    column(:description) { |book| p truncate(book.description, length: 60) }
    column(:price) { |book| number_to_currency book.price }
    actions
  end

  # form do |f|
    # f.inputs 'Book details' do
      # f.input :title
      # f.input :description
      # f.input :year
      # f.input :height
      # f.input :width
      # f.input :thickness
      # f.input :price
      # f.inputs do
        # f.has_many :authors, heading: 'Authors',
          # allow_destroy: true do |a|
          # a.input :full_name
        # end
      # end
    # end
    # f.actions
  # end
end
