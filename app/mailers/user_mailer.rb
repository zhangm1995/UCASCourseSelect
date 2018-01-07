class UserMailer < ApplicationMailer
	default :from => "zhangm1995@126.com" 
	def user_mailer(grade) 
		@grade=grade
   		mail(:to => @grade.user.email, :subject => "成绩通知") 
  	end 
end
