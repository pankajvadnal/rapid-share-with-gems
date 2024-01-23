require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      it 'signs in the user' do
        post :create, params: { user: { email: user.email, password: user.password } }
        expect(controller.current_user).to eq user
      end

      it 'redirects to the root path after sign in' do
        post :create, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid credentials' do
      it 'does not sign in the user' do
        post :create, params: { user: { email: user.email, password: 'invalid_password' } }
        expect(controller.current_user).to be_nil
      end

      it 'renders the new template with status 401' do
        post :create, params: { user: { email: user.email, password: 'invalid_password' } }
        expect(response).to render_template :new
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    it 'signs out the user' do
      sign_in user
      delete :destroy
      expect(controller.current_user).to be_nil
    end

    it 'redirects to the root path after sign out' do
      sign_in user
      delete :destroy
      expect(response).to redirect_to root_path
    end
  end
end
