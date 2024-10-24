module CurationQueue
  extend ActiveSupport::Concern

  included do
    after_commit :notify_curators, on: :create, if: :user_requires_approval?
    if TeSS::Config.solr_enabled
      searchable do
        boolean :unverified do
          from_unverified_or_rejected?
        end
        boolean :shadowbanned do
          from_shadowbanned?
        end
      end
    end
  end

  class_methods do
    def from_verified_users
      joins(user: :role).where.not(users: { role_id: [Role.rejected.id, Role.unverified.id] })
    end
  end

  def user_requires_approval?
    user && user.has_role?('unverified_user') && (user.created_resources - [self]).none?
  end

  def notify_curators
    CurationMailer.user_requires_approval(self.user).deliver_later
  end

  def from_unverified_or_rejected?
    return true unless user # no user set is about the same to me as an unverified user

    user.unverified_or_rejected?
  end

  def from_shadowbanned?
    user&.shadowbanned?
  end
end
