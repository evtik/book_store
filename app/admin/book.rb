ActiveAdmin.register Book do
  permit_params do
    params = [:category_id, :title, :description, :year, :height, :width,
              :thickness, :price, author_ids: [], material_ids: []]
    params
  end

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
    column(:authors) { |book| book.decorate.authors_short }
    column(:description) { |book| markdown_truncate(book.description) }
    column(:price) { |book| number_to_currency book.price }
    actions
  end

  form do |f|
    f.inputs 'Book details' do
      # f.input :image_ids, label: 'Images', as: :check_boxes,
        # # input_html: f.template.image_tag(book_image_path('11'), width: 5, height: 7),
              # collection: Image.all.map { |image| [image.path, image.id] }
      # f.input :images, as: :file, input_html: {multiple: true}
      # f.input :description, as: :file, image_preveiw: true
      # f.input :description_cache, as: :hidden, image_preview: true
      f.input :category_id, label: 'Category', as: :select,
              include_blank: false,
              collection: Category.all.map { |category|
                [category.name.capitalize, category.id]
              }.sort
      f.input :title
      f.input :author_ids, label: 'Authors', as: :check_boxes,
              collection: Author.all.map { |author|
                [[author.last_name, author.first_name].join(', '), author.id]
              }.sort
      f.input :description, input_html: {rows: 5}
      f.input :material_ids, label: 'Materials', as: :check_boxes,
              collection: Material.all.map { |material|
                [material.name.capitalize, material.id]
              }.sort
      f.input :year
      f.input :height
      f.input :width
      f.input :thickness
      f.input :price
    end
    f.actions
  end
end
