module AccountRelations
  extend ActiveSupport::Concern

  included do
    before_action -> { set_account }, only: %i[create_relation update_relation destroy_relation account_relations]
  end

  def create_relation
    liked_account = Account.find(params[:liked_account_id])
    @account.outgoing_relations.create(linked: liked_account, relation_strength: params[:relation_strength])
    redirect_to @account
  end

  def update_relation
    liked_account = Account.find(params[:liked_account_id])
    relation = @account.outgoing_relations.find_or_initialize_by(liked: liked_account)
    relation.update(relation_strength: params[:relation_strength])
    redirect_to @account
  end

  def manage_relation(liker, liked, strength, option='add')
    if liker != liked
      relation = liker.outgoing_relations.find_or_initialize_by(liked: liked)
      if relation.relation_strength.nil?
        relation.relation_strength = 0
      end
      case option
      when 'remove'
        relation.relation_strength -= strength
      when 'expo'
        relation.relation_strength *= strength
      when 'div'
        relation.relation_strength /= strength
      else
        relation.relation_strength += strength
      end
      relation.save!
    end
  end

  def destroy_relation
    relation = @account.outgoing_relations.find(params[:id])
    relation.destroy
    redirect_to @account
  end

  def ours_relations(liker, quantity = 0)
    @current_account_id = liker.id
    @relations = if quantity === 0
                   Account.joins("LEFT JOIN followability_relationships ON followability_relationships.followable_id = accounts.id AND followability_relationships.followable_type = 'Account' AND followability_relationships.followerable_id = @current_account_id")
                            .joins("LEFT JOIN relationships ON relationships.liked_id = accounts.id AND relationships.liker_id = @current_account_id")
                            .where("relationships.id IS NOT NULL AND followability_relationships.id IS NULL").limit(45).order(activity_rate: :desc, id: :desc)
                 else
                   Account.joins("LEFT JOIN followability_relationships ON followability_relationships.followable_id = accounts.id AND followability_relationships.followable_type = 'Account' AND followability_relationships.followerable_id = @current_account_id")
                          .joins("LEFT JOIN relationships ON relationships.liked_id = accounts.id AND relationships.liker_id = @current_account_id")
                          .where("relationships.id IS NOT NULL AND followability_relationships.id IS NULL").limit(quantity).order(activity_rate: :desc, id: :desc)
                 end
  end
  
  def best_relations(liker, quantity = 0)
    @current_account_id = liker.id
    @relations = if quantity === 0
                   Account.joins("LEFT JOIN followability_relationships ON followability_relationships.followable_id = accounts.id AND followability_relationships.followable_type = 'Account' AND followability_relationships.followerable_id = @current_account_id")
                          .where("followability_relationships.id IS NULL").limit(45)
                          .order("activity_rate DESC")
                 else
                   Account.joins("LEFT JOIN followability_relationships ON followability_relationships.followable_id = accounts.id AND followability_relationships.followable_type = 'Account' AND followability_relationships.followerable_id = @current_account_id")
                          .where("followability_relationships.id IS NULL").limit(quantity)
                          .order("activity_rate DESC")
                 end
  end


  private

  def set_account
    @account = Account.find(params[:account_id])
  end
end
