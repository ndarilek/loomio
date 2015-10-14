class Webhooks::Slack::MotionOutcomeUpdated < Webhooks::Slack::Base

  def attachment_fallback
    "*#{eventable.name}*\n#{eventable.outcome}\n"
  end

  def attachment_title
    proposal_link(eventable)
  end

  def attachment_text
    eventable.outcome
  end

  def attachment_fields
    [view_motion_on_loomio]
  end

  def attachment_color
  end

  private

  def eventable_name
    eventable.name
  end
end
