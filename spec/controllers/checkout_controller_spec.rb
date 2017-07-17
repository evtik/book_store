describe CheckoutController do
  context 'guest user' do
    describe 'GET address' do
      it 'redirects to login page' do
        get :address
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'logged in user' do
    let(:user) { create(:user) }
    before do
      sign_in(user)
    end

    context 'GET address' do
      before do
        create_list(:book_with_authors_and_materials, 3)
      end

      it 'renders :address template' do
        get :address, session: { cart: { 1 => 1, 2 => 2, 3 => 3 } }
        expect(response).to render_template(:address)
      end

      it 'assigns values to instance variables' do
        get :address, session: {
          cart: { 1 => 1, 2 => 2, 3 => 3 },
          items_total: 6.0,
          order_subtotal: 5.4
        }
        expect(assigns(:countries).length).to be > 0
        order = assigns(:order)
        expect(order).to be_truthy
        expect(order.billing).to be_truthy
        expect(order.shipping).to be_truthy
        expect(order.items_total).to eq(6.0)
        expect(order.subtotal).to eq(5.4)
      end
    end
  end
end
