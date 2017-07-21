include AbstractController::Translation

describe UserSettingsController do
  context 'logged in user' do
    let(:user) { create(:user) }

    shared_examples_for 'redirects back' do
      scenario 'to user_settings#show' do
        expect(response).to redirect_to(user_settings_path(user))
      end
    end

    shared_examples_for 'with errors' do
      scenario 'render template :show' do
        expect(response).to render_template(:show)
      end
    end

    before do
      sign_in(user)
    end

    context 'GET show' do
      before { get :show, params: { id: user } }

      it 'renders :show template' do
        expect(response).to render_template(:show)
      end

      it 'assigns values to @billing and @shipping' do
        expect(assigns(:billing)).to be_truthy
        expect(assigns(:shipping)).to be_truthy
      end
    end

    context 'POST update_address' do
      context 'with existing address' do
        let(:address) { create(:address, user: user) }

        context 'with valid data' do
          before do
            post :update_address, params: {
              address: {
                billing: attributes_for(:address, city: 'Updated')
                  .merge(id: address.id),
                shipping: attributes_for(:address, address_type: 'shipping')
              },
              billing: t('user_settings.show.save'),
              id: user.id
            }
          end

          scenario 'updates address in database' do
            address.reload
            expect(address.city).to eq('Updated')
          end

          it_behaves_like 'redirects back'
        end

        context 'with invalid data' do
          before do
            post :update_address, params: {
              address: {
                billing: attributes_for(:address, city: 'Updated',
                                                  zip: 'abcdef')
                  .merge(id: address.id),
                shipping: attributes_for(:address, address_type: 'shipping')
              },
              billing: t('user_settings.show.save'),
              id: user.id
            }
          end

          scenario 'does not update address in database' do
            address.reload
            expect(address.city).not_to eq('Updated')
          end

          it_behaves_like 'with errors'
        end
      end

      context 'with non-existent address' do
        context 'with valid data' do
        end

        context 'with invalid data' do
        end
      end
    end
  end

  context 'guest user' do
    describe 'GET show' do
      it 'redirects to login page' do
        get :show, params: { id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
