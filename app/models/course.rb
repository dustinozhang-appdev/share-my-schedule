# == Schema Information
#
# Table name: courses
#
#  id           :integer          not null, primary key
#  currentcount :integer
#  description  :string
#  maxcapacity  :integer
#  name         :string
#  professor    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Course < ApplicationRecord
  validates :maxcapacity, :presence => true
  validates :currentcount, :presence => true
  validates :name, :presence => true
  validates :professor, :presence => true
end
