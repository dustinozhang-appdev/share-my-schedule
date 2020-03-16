class AddCourse1ToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :course1, :integer
  end
end
