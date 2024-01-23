require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect do
          post :create, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the root path after sign up' do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        expect do
          post :create, params: { user: { username: 'invalid' } }
        end.not_to change(User, :count)
      end

      it 'renders the new template with status 422' do
        post :create, params: { user: { username: 'invalid' } }
        expect(response).to render_template :new
        expect(response.status).to eq 422
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }

    it 'renders the edit template' do
      sign_in user
      get :edit
      expect(response).to render_template :edit
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }

    context 'with valid parameters' do
      it 'updates the user' do
        sign_in user
        put :update, params: { user: { username: 'new_username' } }
        user.reload
        expect(user.username).to eq 'new_username'
      end

      it 'redirects to the after_update_path_for after successful update' do
        sign_in user
        put :update, params: { user: { username: 'new_username' } }
        expect(response).to redirect_to controller.after_update_path_for(user)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the user' do
        sign_in user
        put :update, params: { user: { username: 'short' } }
        user.reload
        expect(user.username).not_to eq 'short'
      end

      it 'renders the edit template with status 422' do
        sign_in user
        put :update, params: { user: { username: 'short' } }
        expect(response).to render_template :edit
        expect(response.status).to eq 422
      end
    end
  end
end
