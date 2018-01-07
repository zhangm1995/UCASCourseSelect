require 'test_helper'

class GradesControllerTest < ActionController::TestCase

  def setup
    @test_grade_student = User.find_by_id(36)#"兆廷婷"学生
    @test_grade_teacher = User.find_by_id(2)#"胡伟武"老师
    @test_student_zm = User.find_by_id(236)#张咪 学生，有效的邮箱
    @test_grade_course = Course.find_by_id(1)#计算机体系结构
    @test_grade = Grade.find_by_id(1181)
  end

  test "学生确认选课单" do
    get :studentConfirm, id: @test_grade_student.id, stu_id:@test_grade_student.id
    assert_redirected_to(:controller => "courses", :action => "index")
    test_result_content='已经确认选课单，请等待导师审核'
    assert_equal( test_result_content, flash[:success]) 
  end

  test "导师审核选课单" do
    get :teacherConfirm, id: @test_grade_teacher.id,  stu_id:@test_grade_student.id
    assert_redirected_to(:controller => "courses", :action => "stuCourseList",
      :stu_id=>@test_grade_student.id)
    test_result_content='已经审核该同学的选课单'
    assert_equal( test_result_content, flash[:success]) 
  end

end
