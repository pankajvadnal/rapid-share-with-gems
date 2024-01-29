require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'attributes' do
    it { is_expected.to have_db_column(:uuid).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:file).of_type(:string) }
    it { is_expected.to have_db_column(:upload_date).of_type(:datetime) }
    it { is_expected.to have_db_column(:public_share).of_type(:boolean) }
    it { is_expected.to have_db_index(:uuid).unique }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:uuid) }
    it { is_expected.to validate_uniqueness_of(:uuid) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:file) }
    it { is_expected.to validate_presence_of(:upload_date) }
    it { is_expected.to validate_inclusion_of(:public_share).in_array([true, false]) }
  end

  describe 'callbacks' do
    describe 'before_validation' do
      it 'generates a UUID if none is present' do
        document = Document.new
        expect(document.uuid).to be_present
      end

      it 'does not overwrite an existing UUID' do
        existing_uuid = SecureRandom.uuid
        document = Document.new(uuid: existing_uuid)
        expect(document.uuid).to eq(existing_uuid)
      end
    end

    describe 'after_destroy' do
      it 'purges the attached file' do
        document = create(:document)
        file = fixture_file_upload('spec/support/files/example.pdf', 'application/pdf')

        document.file.attach(file)
        expect(document.file).to be_attached

        expect { document.destroy }.to change { document.file.attached? }.from(true).to(false)
      end
    end
  end
end
