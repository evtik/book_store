describe CheckoutController do
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

    context 'POST submit_address' do
      it 'with valid data redirects to checkout#delivery' do
        post :submit_address, params: {
          order: {
            billing: attributes_for(:address, address_type: 'billing'),
            shipping: attributes_for(:address, address_type: 'shipping')
          }
        }, session: { order: {} }
        expect(response).to redirect_to(checkout_delivery_path)
      end

      it 'with invalid data redirects back to checkout#address' do
        post :submit_address, params: {
          order: {
            billing: attributes_for(:address, address_type: 'billing',
                                              city: '2822'),
            shipping: attributes_for(:address, address_type: 'shipping')
          }
        }, session: { order: {} }
        expect(response).to redirect_to(checkout_address_path)
      end
    end

    context 'GET delivery' do
      let!(:shipments) { create_list(:shipment, 3) }

      it 'renders :delivery template' do
        get :delivery, session: { order: {} }
        expect(response).to render_template(:delivery)
      end

      it 'assigns shipment to @order' do
        get :delivery, session: { order: {} }
        order = assigns(:order)
        expect(order.shipment_id).to eq(1)
        expect(order.shipment.method).to eq(shipments.first.method)
      end
    end

    context 'POST submit_delivery' do
      it 'with shipment present redirects to checkout#payment' do
        post :submit_delivery,
             params: { shipment: attributes_for(:shipment) },
             session: { order: {} }
        expect(response).to redirect_to(checkout_payment_path)
      end

      it 'with no shipment redirects back to checkout#delivery' do
        post :submit_delivery, session: { order: {} }
        expect(response).to redirect_to(checkout_delivery_path)
      end
    end

    context 'GET payment' do
      before do
        get :payment, session: {
          order: { shipment: attributes_for(:shipment) }
        }
      end

      it 'renders :payment template' do
        expect(response).to render_template(:payment)
      end

      it 'assigns value to @order.card' do
        expect(assigns(:order).card).to be_truthy
      end
    end

    context 'POST submit_payment' do
      it 'with valid payment data redirects to checkout#confirm' do
        post :submit_payment,
             params: { order: { card: attributes_for(:credit_card) } },
             session: { order: {} }
        expect(response).to redirect_to(checkout_confirm_path)
      end

      it 'with invalid payment data redirects to checkout#payment' do
        invalid_card = attributes_for(:credit_card, cardholder: '234&lj@')
        post :submit_payment,
             params: { order: { card: invalid_card } },
             session: { order: {} }
        expect(response).to redirect_to(checkout_payment_path)
      end
    end
  end

  context 'guest user' do
    describe 'GET address' do
      it 'redirects to login page' do
        get :address
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST submit_address' do
      it 'redirects to login page' do
        post :submit_address
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET delivery' do
      it 'redirects to login page' do
        get :delivery
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST submit_delivery' do
      it 'redirects to login page' do
        post :submit_delivery
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET payment' do
      it 'redirects to login page' do
        get :payment
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST submit_payment' do
      it 'redirects to login page' do
        post :submit_payment
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
