require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  def setup
    @test_course = Course.find_by_id(1)#计算机体系结构
    @test_teacher=User.find_by_id(2)#胡伟武老师
    @test_student=User.find_by_id(36)#"兆廷婷"学生

    @test_coursename=Course.find_by_name("高级软件工程")
    @test_coursetype=Course.find_by_course_type("专业核心课")
    @test_courseteacher=User.find_by_id(4)##罗铁坚老师
  end
  
  test "创建新课程" do
    course_params={"name"=>"计算机体系结构-2",
      "course_type"=>"专业核心课",
      "teaching_type"=>"讲授",
      "exam_type"=>"闭卷",
      "credit"=>"60/3.0",
      "limit_num"=>"100",
      "class_room"=>"待分配",
      "course_time"=>"周五(9-11)",
      "course_week"=>"第2-21周",
      "course_code"=>""
   } 
    post :create, "course"=> course_params
    assert_redirected_to(:controller =>"courses",:action =>"index")
    test_result_content='新课程申请成功'
    assert_equal(test_result_content, flash[:success])    
  end

  test "按照id查看课程" do
    assert_equal(@test_course.name, "计算机体系结构")
  end

  test "查看详情detail" do
    get :detail, id: @test_course.id
    assert_response :success
    test_h3_content="课程详情: "+@test_course.name
    assert_select "h3", test_h3_content
  end

  test "查看学生的课程表" do
    get :schedule, id: @test_teacher.id,schID: @test_student.id
    assert_response :success
    assert_select "[name='周一9']", @test_course.name
    assert_select "[name='周一10']", @test_course.name
    assert_select "[name='周一11']", @test_course.name
  end

  test "导师查看学生的选课列表" do
    get :mystudent, id: @test_teacher.id
    assert_response :success
    test_h3_content="我的学生(7名)"
    assert_select "h3", test_h3_content
  end

  test "导师查看某学生的选课详情" do
    get :stuCourseList, stu_id: @test_student.id,id:@test_teacher.id
    assert_response :success
    test_h3_content="兆廷婷的选课列表"
    assert_select "h3", test_h3_content
  end

   test "输入条件查询课程" do
    get :showcourse, name: @test_coursename,course_type: @test_coursetype,user_id: @test_courseteacher.id
    assert_response :success
    test_h3_content="学期课表"
    assert_select "h3", test_h3_content
  end
  

end
