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
    column :title
    column 'Image' do |book|
      image = MiniMagick::Image.open(book_image_path(book.images.first.path))
      image_tag(image.resize('100x100'))
    end
    column 'Description' do |book|
      p truncate(book.description)
    end
    column :year
    column :height
    column :width
    column :thickness
    column :price
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
