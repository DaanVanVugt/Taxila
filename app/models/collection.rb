class Collection < ApplicationRecord
  include PublicActivity::Model
  include LogParameterChanges
  include Searchable
  include HasFriendlyId
  include CurationQueue
  include Collaboratable

  has_many :collection_materials
  has_many :collection_events
  has_many :materials, through: :collection_materials
  has_many :events, through: :collection_events

  # has_one :owner, foreign_key: "id", class_name: "User"
  belongs_to :user

  # Remove trailing and squeezes (:squish option) white spaces inside the string (before_validation):
  # e.g. "James     Bond  " => "James Bond"
  auto_strip_attributes :title, :description, :image_url, squish: false
  after_save do
    index_items if saved_change_to_title?
  end
  after_destroy do
    index_items
  end

  validates :title, presence: true

  clean_array_fields(:keywords)
  update_suggestions(:keywords)

  has_image(placeholder: TeSS::Config.placeholder['collection'])

  if TeSS::Config.solr_enabled
    # :nocov:
    searchable do
      text :title
      text :description
      string :title
      string :sort_title do
        title.downcase.gsub(/^(an?|the) /, '')
      end
      string :user do
        user.username.to_s unless user.blank?
      end
      string :keywords, multiple: true

      string :user, multiple: true do
        [user.username, user.full_name].reject(&:blank?) if user
      end

      integer :collaborator_ids, multiple: true
      integer :user_id
      boolean :public
      time :created_at
      time :updated_at
      integer :collaborator_ids, multiple: true
    end
    # :nocov:
  end

  # Overwrites a collections materials and events.
  # [] or nil will delete
  def update_resources_by_id(materials = [], events = [])
    update_attribute('materials', materials.uniq.collect { |material| Material.find_by_id(material) }.compact) if materials
    update_attribute('events', events.uniq.collect { |event| Event.find_by_id(event) }.compact) if events
  end

  def self.facet_fields
    %w[keywords user]
  end

  def self.visible_by(user)
    if user&.is_admin?
      all
    elsif user
      references(:collaborations).includes(:collaborations)
                                 .where("#{table_name}.public = :public OR #{table_name}.user_id = :user OR collaborations.user_id = :user",
                                        public: true, user: user)
    else
      where(public: true)
    end
  end

  # implement methods to allow processing as resource
  def last_scraped
    nil
  end

  def content_provider
    nil
  end

  def scientific_topics
    []
  end

  private

  def index_items
    return unless TeSS::Config.solr_enabled

    materials.each(&:solr_index)
    events.each(&:solr_index)
  end
end
