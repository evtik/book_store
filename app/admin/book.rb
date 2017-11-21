ActiveAdmin.register Book do
  permit_params :category_id, :title, :description, :year, :height,
                :width, :thickness, :price, :main_image,
                author_ids: [], material_ids: [], images: []

  batch_action :destroy do |ids|
    batch_action_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: t('.deleted_message')
  end

  index do
    selectable_column
    column(t('.book.image')) do |book|
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
      row(t('.book.images')) do |book|
        if book.images.present?
          ul class: 'images-row' do
            book.images.each do |image|
              li image_tag(image.url(:small))
            end
          end
        end
      end
      row :description
      row(t('.book.dimensions')) { |book| book.decorate.dimensions }
      row(:price) { |book| number_to_currency book.price }
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs t('.book.book_details') do
      image_hint = if f.object.main_image.present?
                     image_tag(f.object.main_image.url(:thumb))
                   end
      f.input :main_image, as: :file, hint: image_hint

      images_hint = if f.object.images.present?
                      f.object.images.map { |image|
                        '<span class="row-thumb">' <<
                          image_tag(image.url(:thumb)) <<
                          '</span>'
                      }.join.html_safe
                    end
      f.input :images, as: :file, input_html: { multiple: true },
                       hint: images_hint

      f.input :category_id, label: t('.book.category'), as: :select,
                            collection: Category.all.map { |category|
                              [category.name.capitalize, category.id]
                            }.sort
      f.input :title
      f.input :author_ids, label: t('.book.authors'), as: :check_boxes,
              collection: Author.all.map { |author|
                [[author.last_name, author.first_name].join(', '), author.id]
              }.sort
      f.input :description, input_html: { rows: 5 }
      f.input :material_ids, label: t('.book.materials'), as: :check_boxes,
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
