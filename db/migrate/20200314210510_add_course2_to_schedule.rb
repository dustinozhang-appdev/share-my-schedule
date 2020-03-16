class AddCourse2ToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :course2, :integer
  end
end
