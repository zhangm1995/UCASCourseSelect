class AddDegreeToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :degree_course, :boolean
  end
end
