describe CartController do
  describe 'GET index' do
    it 'renders :index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns order total variables' do
      create_list(:book_with_authors_and_materials, 3)
      get :index, session: { cart: { 1 => 1, 2 => 2, 3 => 3 } }
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

    it 'redirects back to where the book was added to cart' do
      expect(response).to redirect_to(:back)
    end
  end

  shared_examples 'both update and remove' do
    it 'redirect back to cart' do
      expect(response).to redirect_to(cart_path)
    end
  end

  describe 'POST update' do
    context 'quantities' do
      before do
        create_list(:book_with_authors_and_materials, 3)
        session[:cart] = { '1' => 1, '2' => 2, '3' => 3 }
        post :update, params: { quantities: { 1 => 4, 2 => 5, 3 => 6 } }
      end

      it 'updates book quantities in cart' do
        expect(session[:cart]['1']).to eq(4)
        expect(session[:cart]['2']).to eq(5)
        expect(session[:cart]['3']).to eq(6)
      end

      it_behaves_like 'both update and remove'
    end

    context 'coupon' do
      before do
        create_list(:book_with_authors_and_materials, 3)
        session[:cart] = { '1' => 1, '2' => 2, '3' => 3 }
      end

      it 'with valid coupon code' do
        create(:coupon)
        post :update, params: {
          quantities: { 1 => 1, 2 => 2, 3 => 3 },
          coupon: '123456'
        }
        expect(session[:coupon_id]).to eq(1)
        expect(session[:discount]).to eq(10)
        expect(response).to redirect_to(cart_path)
      end

      it 'with invalid coupon code' do
        create(:coupon)
        post :update, params: {
          quantities: { 1 => 1, 2 => 2, 3 => 3 },
          coupon: '222222'
        }
        expect(session[:coupon_id]).to be_nil
        expect(session[:discount]).to be_nil
        expect(response).to redirect_to(cart_path)
      end
    end
  end

  describe 'POST remove' do
    before do
      create_list(:book_with_authors_and_materials, 3)
      session[:cart] = { '1' => 1, '2' => 2, '3' => 3 }
      post :remove, params: { id: 3 }
    end

    it 'removes item from cart' do
      expect(session[:cart]['3']).to be_nil
    end

    it_behaves_like 'both update and remove'
  end
end
