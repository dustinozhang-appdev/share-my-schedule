class AddCurrentcountToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :currentcount, :integer
  end
end
