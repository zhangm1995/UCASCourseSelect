class AddConfirmToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :stu_confirm, :boolean
    add_column :grades, :teacher_confirm, :boolean
  end
end
