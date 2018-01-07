class ExportsController < ApplicationController
  
  def index
    @type=params[:type]
    if @type=='students_list'
      #老师导出选课名单
      @course=Course.find_by_id(params[:course_id])
      @exports=@course.grades
      @filename="选课名单_"+@course.name+".xlsx"
    elsif @type=='grades_list'
      #老师导出成绩单
      @course=Course.find_by_id(params[:course_id])
      @exports=@course.grades
      @filename="成绩单_"+@course.name+".xlsx"

      ##liupan 学生选课和成绩导出
    elsif @type=='mycourse_list'
      #学生导出自己选课单
      @user=User.find_by_id(params[:user_id])
      @course=@user.courses
      @exports=@course
      @filename=@user.name+"_选课单.xlsx"
    elsif @type=='mygrade_list'
      #学生导出自己成绩单
      @user=User.find_by_id(params[:user_id])
      @grade=@user.grades
      @exports=@grade
      @filename=@user.name+"_成绩单.xlsx"
    end
    
  respond_to do |format|
  format.html
  format.xlsx {
    response.headers['Content-Disposition'] = 'attachment; filename='+@filename
  }
  end
  end

end

