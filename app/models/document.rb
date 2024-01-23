class Document < ApplicationRecord

  belongs_to :user
  has_one_attached :file
  after_destroy :purge_file
  before_validation :generate_uuid, on: :create

  validates :uuid, presence: true, uniqueness: true
  validates :name, presence: true
  validates :file, presence: true
  validates :upload_date, presence: true
  validates :public_share, inclusion: { in: [true, false] }

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end

  validate :file_attached?

  def file_attached?
    errors.add(:file, 'must be attached') unless file.attached?
  end

  private

  def purge_file
    file.purge if file.attached?
  end

end
