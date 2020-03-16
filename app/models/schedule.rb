# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  course1    :integer
#  course2    :integer
#  course3    :integer
#  course4    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer
#

class Schedule < ApplicationRecord

  
end
