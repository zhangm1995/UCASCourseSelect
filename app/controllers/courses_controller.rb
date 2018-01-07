class CoursesController < ApplicationController

  before_action :student_logged_in, only: [:select, :quit, :list]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :destroy, :update, :open, :close]#add open by qiao
  before_action :logged_in, only: :index

  #-------------------------for teachers----------------------

  def new
    @course=Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      current_user.teaching_courses<<@course
      redirect_to courses_path, flash: {success: "新课程申请成功"}
    else
      flash[:warning] = "信息填写有误,请重试"
      render 'new'
    end
  end

  def edit
    @course=Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    if @course.update_attributes(course_params)
      flash={:info => "更新成功"}
    else
      flash={:warning => "更新失败"}
    end
    redirect_to courses_path, flash: flash
  end

  ###zm添加###查看课程详情
  def detail
    @course=Course.find_by_id(params[:id])
  end

  ###zm添加###生成课程表
  def schedule
    #老师和学生都可以查看课程表
    currentID=params[:id]
    selectedID=params[:schID]
    if currentID==selectedID
      #说明是自己查看自己的课表
      schedule_courses=current_user.teaching_courses if teacher_logged_in?
      schedule_courses=current_user.courses if student_logged_in?
    else
      #说明是老师查看学生的课表
      schedule_courses=User.find_by_id(params[:schID]).courses
    end

    @course_hash=Hash.new
    #初始化hash
    initial_course=Course.new    
    i=0
    for i in 0..11        
        @course_hash["周一#{i}"]=initial_course
        @course_hash["周二#{i}"]=initial_course
        @course_hash["周三#{i}"]=initial_course
        @course_hash["周四#{i}"]=initial_course
        @course_hash["周五#{i}"]=initial_course
        @course_hash["周六#{i}"]=initial_course
        @course_hash["周日#{i}"]=initial_course      
        i=i+1
    end 

    #给hash赋值，key：周五9   value:课程对象
    schedule_courses.each do |course|
      #数据库中的上课时间需要规范=>英文符号  周五(9-11)
      time=course.course_time
      timelength=time.length
      #提取上课时间是星期几=>   周五
      course_day=time[0..1]
      #获取分割线-的位置
      split_index=time.index("-")
      #开始的上课节数  9
      begin_class=time[3..split_index-1]
      #结束的上课节数 11
      end_class=time[split_index+1..timelength-2]
      #从开始节数到结束节数，给hash赋值 周五9 周五10 周五11
      j=begin_class
      for j in begin_class..end_class do
        hash_key=course_day+j
        @course_hash[hash_key]=course
      end
    end  
  end

  #zm添加##导师查看自己学生的选课单
  def stuCourseList
    @selectedStudent=User.find_by_id(params[:stu_id])
    @stu_courses=@selectedStudent.courses
    ##待审核的选课单
    @stu_course_list=@selectedStudent.grades.order('id')
  end

   #zm添加##导师查看自己学生的选课列表
  def mystudent
    @mystudent=User.where(:supervisor => params[:id])
  end

  def open
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: true)
    redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
  end

  def close
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: false)
    redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
  end

  def destroy
    @course=Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash={:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  #-------------------------for students----------------------

##liupan修改选修课程界面
  def list
    #-------QiaoCode--------
   @course=Course.where(:open=>true)
    tmp=[]
    @course.each do |course|
      if course.open==true 
       tmp<<course
      end
    end
    @course=tmp
    ##zm修改##该同学的选课单
    @stu_course_list=current_user.grades.order('id') if student_logged_in?
  end

#liupan添加学期课表，学生和老师都可以看#
  def showcourse
    @course=Course.order('created_at DESC')
  end

#pan添加多条件搜索课表#
  def search_json
    @courses=Course.search_courses(params, current_user)
    render json: @courses.as_json(:include=>:teacher)
  end
########

##liupan 处理选课冲突
  def select
      @course=Course.find_by_id(params[:id])

      ##
      @degree_course=params["degreeCourse"]
      if( @degree_course=="请选择")
        flash={:error=>"请选择选择学位课属性"}
        redirect_to list_courses_path, flash: flash

      else
      ##
        count=0
        current_user.courses.each do |selected_course|
           tmp1=(@course.course_time.split("(")[1]).split("-")[0].to_i
           tmp2=((@course.course_time.split("(")[1]).split(")")[0]).split("-")[1].to_i
           smp1=(selected_course.course_time.split("(")[1]).split("-")[0].to_i
           smp2=((selected_course.course_time.split("(")[1]).split(")")[0]).split("-")[1].to_i

           week_begin=@course.course_week.tr("第","").split("-")[0].to_i
           week_end=@course.course_week.tr("周","").split("-")[1].to_i
           selected_week_begin=selected_course.course_week.tr("第","").split("-")[0].to_i
           selected_week_end=selected_course.course_week.tr("周","").split("-")[1].to_i
     
           if selected_course.name==@course.name 
              count=count+1
           end

           if ((((week_begin>=selected_week_begin)&&(week_begin<=selected_week_end))||((selected_week_begin>=week_begin)&& (selected_week_begin.to_i<=week_end)))&&((@course.course_time.split("(")[0])==(selected_course.course_time.split("(")[0]))&&(((tmp1>=smp1) &&(tmp1<=smp2))||((smp1>=tmp1)&&(smp1<=tmp2))))
               count=count+1
           end
     
        end 
       
        if count==0
          current_user.courses<<@course

          ##liuapn 增加学位课属性判断
          current_user.grades.each do |grade|
             if grade.course.id==@course.id
              @grade=grade
             end
          end

          @grade.course=@course
          if @degree_course=="是"
              @grade.degree_course=true
          else
              @grade.degree_course=false
          end
          current_user.grades<<@grade
          
          ##
          flash={:suceess => "成功选择课程: #{@course.name}"}
        else
          flash={:error=>"选课冲突，请重新选择"}
        end
    
       redirect_to courses_path, flash: flash
     end
   end

  def quit
    @course=Course.find_by_id(params[:id])
    current_user.courses.delete(@course)
    flash={:success => "成功退选课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end


  #-------------------------for both teachers and students----------------------

##liupan修改student"已选课程"界面，统计学分
  def index
    @course=current_user.teaching_courses.order('id') if teacher_logged_in?
    @course=current_user.courses.order('id') if student_logged_in?
    ##zm修改##待确认的选课单
    @stu_course_list=current_user.grades.order('id') if student_logged_in?

    if student_logged_in?
       credit=0
       credit_coursetype=0
       @course.each do |course|
           credit=credit+course.credit.split("/")[1].to_i
            current_user.grades.each do |grade|
               if grade.course.id==course.id
                     if grade.degree_course==true
                          credit_coursetype=credit_coursetype+course.credit.split("/")[1].to_i                 
                     end
                end
            end
           end
           @totalcredit=credit
           @typecredit=credit_coursetype
           
    end

  end


  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def course_params
    params.require(:course).permit(:course_code, :name, :course_type, :teaching_type, :exam_type,
                                   :credit, :limit_num, :class_room, :course_time, :course_week)
  end


end
