class Trade < ActiveRecord::Base
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants


  def completed?

  end

  def create_participants(organizer_user, participant_reddit_username)
    participants.build(user: organizer_user, accepted_at: Time.now)
    to_invite = participants.build(user: User.find_or_create_by(username: participant_reddit_username))
    save!
    TradeInviteJob.perform_later to_invite.id

    true
  rescue ActiveRecord::RecordInvalid
    false
  end


  def waiting_for_approval?(user)
  end


  def to_s
    users.map(&:username).join(' and ').tap {|s| s << ": #{agreement}" if agreement?}
  end
end
