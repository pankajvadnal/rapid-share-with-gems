require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  # Include Devise test helpers
  include Devise::Test::ControllerHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }

    context 'with valid credentials' do
      it 'signs in the user' do
        post :create, params: { user: { email: user.email, password: user.password } }
        expect(subject.current_user).to eq(user)
      end

      it 'redirects to the root path' do
        post :create, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid credentials' do
      it 'does not sign in the user' do
        post :create, params: { user: { email: user.email, password: 'wrong_password' } }
        expect(subject.current_user).to be_nil
      end

      it 'renders the new template' do
        post :create, params: { user: { email: user.email, password: 'wrong_password' } }
        expect(response).to render_template(:new)
      end
    end
  end
end
