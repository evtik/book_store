ActiveAdmin.register Author do
  permit_params :first_name, :last_name, :description

  index do
    selectable_column
    column :first_name
    column :last_name
    column(:description) { |author| markdown_truncate(author.description) }
    actions
  end

  form do |f|
    f.inputs t('.author.author_details') do
      f.input :first_name
      f.input :last_name
      f.input :description, as: :text, input_html: { rows: 5 }
    end
    f.actions
  end

  controller do
    def new
      @author = AuthorForm.new
    end

    def create
      @author = AuthorForm.from_params(params)
      return render 'new' if @author.invalid?
      author = Author.new(@author.attributes)
      if author.save
        flash[:notice] = t('.created_message')
      else
        flash[:alert] = author.errors.full_messages.first
      end
      redirect_to collection_path
    end

    def edit
      @author = AuthorForm.from_model(Author.find(params[:id]))
    end

    def update
      @author = AuthorForm.from_params(params)
      return render 'edit' if @author.invalid?
      author = Author.find(params[:id])
      author.attributes = @author.attributes
      if author.save
        flash[:notice] = t('.updated_message')
      else
        flash[:alert] = author.errors.full_messages.first
      end
      redirect_to resource_path
    end
  end
end
