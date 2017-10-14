describe CartsController do
  describe 'GET show' do
    it 'renders :show template' do
      get :show
      expect(response).to render_template(:show)
    end

    it 'assigns order total variables' do
      create_list(:book_with_authors_and_materials, 3)
      get :show, session: { cart: { 1 => 1, 2 => 2, 3 => 3 } }
      expect(assigns(:items_total)).to be_truthy
      expect(assigns(:discount)).to be_truthy
      expect(assigns(:order_subtotal)).to be_truthy
    end
  end

  describe 'PUT update' do
    context 'quantities' do
      before do
        create_list(:book_with_authors_and_materials, 3)
        session[:cart] = { '1' => 1, '2' => 2, '3' => 3 }
        put :update, params: { quantities: { 1 => 4, 2 => 5, 3 => 6 } }
      end

      it 'updates book quantities in cart' do
        expect(session[:cart]['1']).to eq(4)
        expect(session[:cart]['2']).to eq(5)
        expect(session[:cart]['3']).to eq(6)
      end

      it 'redirects back to cart' do
        expect(response).to redirect_to(cart_path)
      end
    end

    context 'coupon' do
      before do
        create_list(:book_with_authors_and_materials, 3)
        session[:cart] = { '1' => 1, '2' => 2, '3' => 3 }
      end

      it 'with valid coupon code assigns order discount' do
        create(:coupon)
        post :update, params: {
          quantities: { 1 => 1, 2 => 2, 3 => 3 },
          coupon: '123456'
        }
        expect(session[:coupon_id]).to eq(1)
        expect(session[:discount]).to eq(10)
        expect(response).to redirect_to(cart_path)
      end

      it 'with invalid coupon code assigns no discount' do
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
end
