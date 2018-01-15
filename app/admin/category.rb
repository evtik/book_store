ActiveAdmin.register Category, as: 'book-category' do
  permit_params(:name)

  index do
    selectable_column
    column(:name)
    actions
  end

  form do |f|
    f.inputs(t('.book_category.category_details')) do
      f.input(:name)
    end
    f.actions
  end

  controller do
    def new
      @book_category = CategoryForm.new
    end

    def create
      @book_category = CategoryForm.from_params(params)
      return render('new') if @book_category.invalid?
      Category.create(@book_category.attributes)
      flash[:notice] = t('.created_message')
      redirect_to(collection_path)
    end

    def edit
      @book_category = CategoryForm.from_model(Category.find(params[:id]))
    end

    def update
      @book_category = CategoryForm.from_params(params)
      return render('edit') if @book_category.invalid?
      Category.find(params[:id]).update_attributes(@book_category.attributes)
      flash[:notice] = t('.updated_message')
      redirect_to(resource_path)
    end
  end
end
