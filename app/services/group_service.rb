class GroupService
  def self.create(group:, actor:)
    group.creator = actor
    actor.ability.authorize! :create, group

    group.save! or return false

    if group.is_parent?
      group.update default_group_cover: DefaultGroupCover.sample,
                   subscription: Subscription.new_trial
      ExampleContent.add_to_group(group)
    end

    group.add_admin!(actor)
    group
  end

  def self.update(group:, params:, actor:)
    actor.ability.authorize! :update, group
    group.assign_attributes(params)
    group.group_privacy = params[:group_privacy] if params[:group_privacy]
    group.tap(&:save)
  end

  def self.archive(group:, actor:)
    actor.ability.authorize! :archive, group
    group.archive!
  end
end
