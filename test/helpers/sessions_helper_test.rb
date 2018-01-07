require 'test_helper'

class SessionHelperTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "学生登录" do
    get :create, "session"=>{"email"=>"458732368@qq.com","password"=>"password"}   
    assert_equal( "欢迎回来: 张咪 :)", flash[:info]) 
  end
end
