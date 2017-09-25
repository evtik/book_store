describe OrdersController do
  context 'with logged in user' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    context 'GET index' do
      it 'renders :index template' do
        get :index, params: { id: user }
        expect(response).to render_template(:index)
      end

      it 'assigns value to @orders' do
        create(:book_with_authors_and_materials)
        2.times do
          order = build(:order, user: user)
          order.order_items << build(:order_item, book_id: 1)
          order.shipment = build(:shipment)
          order.save
        end

        get :index, params: { id: user }
        expect(assigns(:orders).length).to eq(2)
      end
    end

    context 'GET show' do
      before do
        create(:book_with_authors_and_materials)
        order = build(:order, user: user)
        order.addresses << build(:address)
        order.order_items << build(:order_item, book_id: 1)
        order.shipment = build(:shipment)
        order.credit_card = build(:credit_card)
        order.save
      end

      it 'renders :show template' do
        get :show, params: { id: user, order_id: 1 }
        expect(response).to render_template(:show)
      end

      it 'assigns value to @order' do
        get :show, params: { id: user, order_id: 1 }
        expect(assigns(:order)).to be_truthy
      end

      it "renders 'not authorized' page with non-authorized user" do
        another_user = create(:user)
        another_order = create(:order, user: another_user)
        get :show, params: { id: user, order_id: another_order }
        expect(response).to render_template(file: '403.html')
      end
    end
  end

  context 'with guest user' do
    describe 'GET index' do
      it 'redirects to login page' do
        get :index, params: { id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET show' do
      it 'redirects to login page' do
        get :show, params: { id: 1, order_id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
