class AddCourse3ToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :course3, :integer
  end
end
