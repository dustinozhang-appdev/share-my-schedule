class AddMaxcapacityToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :maxcapacity, :integer
  end
end
