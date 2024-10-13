class BusinessCard < ApplicationRecord
  belongs_to :continent
  belongs_to :country
  belongs_to :state, foreign_key: :state_id, primary_key: :state_id
  belongs_to :district, foreign_key: :district_id, primary_key: :dist_id
  belongs_to :city, foreign_key: :city_id, primary_key: :city_id
  belongs_to :area, foreign_key: :area_id, primary_key: :area_id
  belongs_to :portal
  belongs_to :owned_by, class_name: 'User', foreign_key: :owned_by_id, optional: true
  belongs_to :created_by, class_name: 'AdminUser', foreign_key: :created_by_id
  belongs_to :managed_by, class_name: 'AdminUser', foreign_key: :managed_by_id
  has_many :faqs, as: :faqable, dependent: :destroy
  has_many :social_media_links, as: :linkable, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy

  # Updated: association for business subcategories
  # has_many :business_sub_categories, -> { where('id = ANY (business_sub_category_ids)') }, class_name: 'BusinessSubCategory'

  BCARD_TYPES = %w[free paid].freeze
  enum bcard_type: %i[free paid]
  enum bank_type: %i[saving current]
  
  has_many :business_seo_profile, as: :seoprofileable, dependent: :destroy
  validates :name, presence: true, length: { maximum: 128 }

  # Nested attributes
  accepts_nested_attributes_for :business_seo_profile, allow_destroy: true
  accepts_nested_attributes_for :social_media_links, allow_destroy: true
  accepts_nested_attributes_for :faqs, allow_destroy: true
  accepts_nested_attributes_for :documents, allow_destroy: true

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    [
      "name", "owner_name", "email", "address", "landmark",
      "mobile", "latitude", "longitude", "bcard_type", "bcard_power",
      "status", "seo_active", "website", "bank_account",
      "bank_ifsc", "bank_type", "qrcode_active", "qrcode_file",
      "created_at", "updated_at", "state_id", "district_id",
      "city_id", "area_id"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [
      "state", "district", "city", "area",
      "business_category", "business_sub_categories",  # Updated to plural
      "business_seo_profile", "social_media_profile"
    ]
  end
end
