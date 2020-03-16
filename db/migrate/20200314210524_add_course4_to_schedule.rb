class AddCourse4ToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :course4, :integer
  end
end
