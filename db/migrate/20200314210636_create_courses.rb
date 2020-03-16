class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :professor
      t.string :description
      t.string :name
      t.string :capacity

      t.timestamps
    end
  end
end
