ActiveAdmin.register Category, as: 'book-category' do
  permit_params :name

  batch_action :destroy do |ids|
    batch_action_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: t('.deleted_message')
  end

  index do
    selectable_column
    column :name
    actions
  end

  form do |f|
    f.inputs t('.book_category.category_details') do
      f.input :name
    end
    f.actions
  end

  controller do
    def new
      @book_category = CategoryForm.new
    end

    def create
      @book_category = CategoryForm.from_params(params)
      return render 'new' if @book_category.invalid?
      book_category = Category.new(@book_category.attributes)
      if book_category.save
        flash[:notice] = t('.created_message')
      else
        flash[:alert] = book_category.error.full_messages.first
      end
      redirect_to collection_path
    end

    def edit
      @book_category = CategoryForm.from_model(Category.find(params[:id]))
    end

    def update
      @book_category = CategoryForm.from_params(params)
      return render 'edit' if @book_category.invalid?
      book_category = Category.find(params[:id])
      book_category.attributes = @book_category.attributes
      if book_category.save
        flash[:notice] = t('.updated_message')
      else
        flash[:alert] = book_category.error.full_messages.first
      end
      redirect_to resource_path
    end
  end
end
