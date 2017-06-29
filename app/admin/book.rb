ActiveAdmin.register Book do
  permit_params :category_id, :title, :description, :year, :height,
                :width, :thickness, :price, :main_image,
                author_ids: [], material_ids: [], images: []

  batch_action :destroy do |ids|
    batch_action_collection.find(ids).each do |book|
      book.destroy
    end
    redirect_to collection_path, notice: 'Deleted!'
  end

  index do
    selectable_column
    column 'Image' do |book|
      image_tag(book.main_image.url(:thumb))
    end
    column(:category) { |book| book.category.name.capitalize }
    column :title
    column(:authors) { |book| book.decorate.authors_short }
    column(:description) { |book| markdown_truncate(book.description) }
    column(:price) { |book| number_to_currency book.price }
    actions
  end

  show do
    attributes_table do
      row(:category) { |book| h5 b capitalize_category(book.category.name) }
      row(:title) { |book| h3 b book.title }
      row(:authors) { |book| h4 book.decorate.authors_full }
      row(:main_image) do |book|
        image_tag(book.main_image.url(:small))
      end
      row('Images') do |book|
        unless book.images.empty?
          ul class: 'images-row' do
            book.images.each do |image|
              li image_tag(image.url(:small))
            end
          end
        end
      end
      row :description
      row('Dimensions') { |book| book.decorate.dimensions }
      row(:price) { |book| number_to_currency book.price }
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Book details' do
      image_hint = if f.object.main_image.present?
                     image_tag(f.object.main_image.url(:thumb))
                   end
      f.input :main_image, as: :file, hint: image_hint

      images_hint = unless f.object.images.empty?
                      f.object.images.map { |image|
                        '<span class="row-thumb">' <<
                          image_tag(image.url(:thumb)) <<
                          '</span>'
                      }.join.html_safe
                    end
      f.input :images, as: :file, input_html: { multiple: true },
                       hint: images_hint

      f.input :category_id, label: 'Category', as: :select,
                            collection: Category.all.map { |category|
                              [category.name.capitalize, category.id]
                            }.sort
      f.input :title
      f.input :author_ids, label: 'Authors', as: :check_boxes,
              collection: Author.all.map { |author|
                [[author.last_name, author.first_name].join(', '), author.id]
              }.sort
      f.input :description, input_html: { rows: 5 }
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
