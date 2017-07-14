describe CartController do
  describe 'GET index' do
    it 'renders :index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns order total variables' do
      create_list(:book_with_authors_and_materials, 3)
      get :index, session: { cart: { 1 => 1, 2 => 2, 3 => 3} }
      expect(assigns(:items_total)).to be_truthy
      expect(assigns(:discount)).to be_truthy
      expect(assigns(:order_subtotal)).to be_truthy
    end
  end

  describe 'POST add' do
    before do
      create(:book_with_authors_and_materials)
      request.env['HTTP_REFERER'] = root_url
      post :add, params: { id: 1, quantity: 5 }
    end

    it 'adds new item to cart' do
      expect(session[:cart]['1']).to eq(5)
    end

    it 'redirects back to where a book was added to cart' do
      expect(response).to redirect_to(:back)
    end
  end
end
