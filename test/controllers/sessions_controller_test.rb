require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  test "学生登录" do
    get :create, "session"=>{"email"=>"458732368@qq.com","password"=>"password"}   
    assert_equal( "欢迎回来: 张咪 :)", flash[:info]) 
  end
  test "老师登录" do
    get :create, "session"=>{"email"=>"teacher1@test.com","password"=>"password"}   
    assert_equal( "欢迎回来: 胡伟武 :)", flash[:info]) 
  end
end
