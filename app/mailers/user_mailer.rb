class UserMailer < ApplicationMailer
	default :from => "458732368@qq.com" 
	def user_mailer(grade) 
		@grade=grade
   		mail(:to => @grade.user.email, :subject => "成绩通知") 
  	end 
end
