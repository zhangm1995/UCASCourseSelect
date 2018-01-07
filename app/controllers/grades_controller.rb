class GradesController < ApplicationController

  before_action :teacher_logged_in, only: [:update]
  def update
    @grade=Grade.find_by_id(params[:id])
    if @grade.update_attributes!(:grade => params[:grade][:grade])
      flash={:success => "#{@grade.user.name} #{@grade.course.name}的成绩已成功修改为 #{@grade.grade}"}
      UserMailer.user_mailer(@grade).deliver
    else
      flash={:danger => "上传失败.请重试"}
    end
    redirect_to grades_path(course_id: params[:course_id]), flash: flash
  end

  def index
    if teacher_logged_in?
      @course=Course.find_by_id(params[:course_id])
      @grades=@course.grades.order('user_id')
    elsif student_logged_in?
      @grades=current_user.grades
    else
      redirect_to root_path, flash: {:warning=>"请先登陆"}
    end


    ##liupan 加学生成绩页面统计通过课程数和课程通过率

    if student_logged_in?
        @grades=current_user.grades 
        courseTotal=0
        passCourse=0
        @grades.each do |grade|
          if grade.grade.to_f >0 
              courseTotal=courseTotal+1
          end
          if grade.grade.to_f >=60
              passCourse=passCourse+1
          end
       end
       @courseTotal=courseTotal
       if courseTotal==0
           @passCourse=passCourse
           @passRate=0
       else
           @passCourse=passCourse
           @passRate=((passCourse/courseTotal)*100).to_f
      end
   end

  end

  ##zm添加##学生确认选课单
  def studentConfirm
    condition="user_id="+params[:stu_id]
    result = Grade.where(:user_id=>params[:stu_id]).update_all("stu_confirm = true")
    if result
      redirect_to courses_path, flash: {:success => "已经确认选课单，请等待导师审核"}
    else
      flash={:danger => "确认选课单失败"}
    end   
  end
  ##zm添加##学生取消确认选课单
  def studentCancel
    condition="user_id="+params[:stu_id]
    result = Grade.where(:user_id=>params[:stu_id]).update_all("stu_confirm = false")
    if result
      redirect_to courses_path, flash: {:success => "已经取消确认"}
    else
      flash={:danger => "取消确认失败"}
    end   
  end
  ##zm添加##导师审核选课单
  def teacherConfirm
    condition="user_id="+params[:stu_id]
    result = Grade.where(:user_id=>params[:stu_id]).update_all("teacher_confirm = true")
    if result
      redirect_to stuCourseList_course_path(stu_id:params[:stu_id]), flash: {:success => "已经审核该同学的选课单"}
    else
      flash={:danger => "审核选课单失败"}
    end  
  end
  


  private

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

end
