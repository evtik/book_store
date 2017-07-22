include AbstractController::Translation

describe UserSettingsController do
  context 'logged in user' do
    let(:user) { create(:user) }

    shared_examples_for 'redirects back' do
      scenario 'to user_settings#show' do
        expect(response).to redirect_to(user_settings_path(user))
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

          scenario 'renders template :show' do
            expect(response).to render_template(:show)
          end
        end
      end

      context 'with non-existent address' do
        context 'with valid data' do
          let(:valid_data) {
            {
              address: {
                billing: attributes_for(:address),
                shipping: attributes_for(:address, address_type: 'shipping')
              },
              shipping: t('user_settings.show.save'),
              id: user.id
            }
          }

          scenario 'creates new address to database' do
            expect {
              post :update_address, params: valid_data
            }.to change(Address, :count).by(1)
          end

          scenario 'redirects back to user_settings#show' do
            post :update_address, params: valid_data
            expect(response).to redirect_to(user_settings_path(user))
          end
        end

        context 'with invalid data' do
          let(:invalid_data) {
            {
              address: {
                billing: attributes_for(:address),
                shipping: attributes_for(:address, address_type: 'shipping',
                                                   phone: 'myphone')
              },
              shipping: t('user_settings.show.save'),
              id: user.id
            }
          }

          scenario 'does not create new address in database' do
            expect {
              post :update_address, params: invalid_data
            }.not_to change(Address, :count)
          end

          scenario 'renders template :show' do
            post :update_address, params: invalid_data
            expect(response).to render_template(:show)
          end
        end
      end
    end

    context 'POST update_email' do
      context 'with valid email' do
        before do
          post :update_email, params: {
            user: { email: 'some@email.com' },
            id: user.id
          }
        end

        scenario 'updates user email in database' do
          user.reload
          expect(user.email).to eq('some@email.com')
        end

        it_behaves_like 'redirects back'
      end

      context 'with invalid email' do
        before do
          post :update_email, params: {
            user: { email: 'email.com' },
            id: user.id
          }
        end

        scenario 'does not update user email in database' do
          user.reload
          expect(user.email).not_to eq('email.com')
        end

        it_behaves_like 'redirects back'
      end

      context 'with email taken by another user' do
        let(:another_user) { create(:user) }

        before do
          post :update_email, params: {
            user: { email: another_user.email },
            id: user.id
          }
        end

        scenario 'does not update user email in database' do
          user.reload
          expect(user.email).not_to eq(another_user.email)
        end

        it_behaves_like 'redirects back'
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

    describe 'POST update_address' do
      it 'redirects to login page' do
        post :update_address, params: { id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST update_email' do
      it 'redirects to login page' do
        post :update_email, params: { id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
