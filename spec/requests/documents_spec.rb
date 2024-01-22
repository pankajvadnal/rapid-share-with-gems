require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
    
    # Include Devise test helpers for controller specs
    include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:document) { create(:document, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new document' do
        expect {
          post :create, params: { document: attributes_for(:document) }
        }.to change(Document, :count).by(1)
      end

      it 'redirects to the documents index page' do
        post :create, params: { document: attributes_for(:document) }
        expect(response).to redirect_to(documents_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new document' do
        expect {
          post :create, params: { document: attributes_for(:document, name: nil) }
        }.to_not change(Document, :count)
      end

      it 'renders the new template' do
        post :create, params: { document: attributes_for(:document, name: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: document.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested document' do
      document # create the document
      expect {
        delete :destroy, params: { id: document.id }
      }.to change(Document, :count).by(-1)
    end

    it 'redirects to the documents index page' do
      delete :destroy, params: { id: document.id }
      expect(response).to redirect_to(documents_path)
    end
  end
end
