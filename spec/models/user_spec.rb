require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'validates uniqueness of email' do
      existing_user = create(:user)
      user = build(:user, email: existing_user.email)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'validates presence of password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'validates length of password' do
      user = build(:user, password: 'short')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 8 characters)')
    end
  end

  describe 'associations' do
    # it { should have_many(:documents) }
    it { is_expected.to have_many(:documents) }

    it 'creates an associated document' do
        user = create(:user)
        expect(user.documents.count).to eq(1)
        expect(user.documents.first).to be_a(Document)
    end
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:name) }
    it { is_expected.to have_db_column(:username) }
    it { is_expected.to have_db_column(:email) }
    it { is_expected.to have_db_column(:encrypted_password) }
    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:username).unique(true) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:username) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:encrypted_password) }
  end

  describe 'factory' do
    it 'is valid' do
      user = build(:user)
      expect(user).to be_valid
      # expect(user.valid?).to be(true)
    end
  end

end
