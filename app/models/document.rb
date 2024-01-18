class Document < ApplicationRecord

  belongs_to :user
  has_one_attached :file

  validates :uuid, presence: true, uniqueness: true
  validates :name, presence: true
  validates :file, presence: true
  validates :upload_date, presence: true

  # Add the public_share attribute
  validates_inclusion_of :public_share, in: [true, false]

  before_validation :generate_uuid, on: :create

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end

  validate :file_attached?

  def file_attached?
    errors.add(:file, 'must be attached') unless file.attached?
  end

end
