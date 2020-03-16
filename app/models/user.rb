# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  private         :boolean
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
  validates(:username,
    {
      :presence => true,
      :uniqueness => { :case_sensitive => false }
    }
  )

  def sent_follow_requests
    return FollowRequest.where({ :sender_id => self.id })
  end

  def received_follow_requests
    return FollowRequest.where({ :recipient_id => self.id })
  end

  def accepted_sent_follow_requests
    return self.sent_follow_requests.where({ :status => "accepted" })
  end

  def accepted_received_follow_requests
    return self.received_follow_requests.where({ :status => "accepted" })
  end

  def pending_follow_requests
    return self.received_follow_requests.where({ :status => "pending" })
  end

  def followers
    array_of_follower_ids = self.accepted_received_follow_requests.pluck(:sender_id)

    return User.where({ :id => array_of_follower_ids })
  end

  def followers_ids
    return self.accepted_received_follow_requests.pluck(:sender_id)
  end

  def following
    array_of_leader_ids = self.accepted_sent_follow_requests.pluck(:recipient_id)

    return User.where({ :id => array_of_leader_ids })
  end

  def following_ids
    return self.accepted_sent_follow_requests.pluck(:recipient_id)
  end

  def following_schedules
    return Schedule.where({:owner_id => self.following_ids}).order({ :updated_at => :desc })
  end 

  def schedule
    return Schedule.where({ :owner_id => self.id})[0]
  end
  
end
