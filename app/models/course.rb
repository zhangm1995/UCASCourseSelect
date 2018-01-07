class Course < ActiveRecord::Base

  has_many :grades
  has_many :users, through: :grades

  belongs_to :teacher, class_name: "User"

  validates :name, :course_type, :course_time, :course_week,
            :class_room, :credit, :teaching_type, :exam_type, presence: true, length: {maximum: 50}


#liupan添加查询课表方法#
  def self.search_courses(params, current_user)
	    courseName= "courses.name LIKE ? ", "%#{params[:query]}%"
	    courseType="courses.course_type LIKE ?", "%#{params[:course_type]}%"
        if "#{params[:teachername]}"==""
		   Course.where(courseName).where(courseType)
	    else
		   @teachers=User.where("users.name like ?", "%#{params[:teachername]}%")
		   tmp=[]
		   @teachers.each do |teacher|
		      tmp<<teacher.id
	       end
		   teacherName="courses.teacher_id in (?)", tmp
		   Course.where(courseName).where(courseType).where(teacherName)
		
	     end
	 
   end

end
