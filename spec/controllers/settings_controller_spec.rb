describe SettingsController do
  context 'logged in user' do
    let(:user) { create(:user) }

    before { sign_in(user) }

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
