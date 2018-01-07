require 'test_helper'
require 'win32ole'

class ExportsControllerTest < ActionController::TestCase

  def setup
    @test_export_course = Course.find_by_id(1)#计算机体系结构
  end

  test "导出选课名单" do
    get :index,course_id: @test_export_course.id,type:'students_list',format: :xlsx
    assert_response :success
    excel = WIN32OLE::new('excel.Application')  
    workbook = excel.Workbooks.Open('D:\用户目录\下载\
    选课名单_计算机体系结构.xlsx')  
    worksheet = workbook.Worksheets(1) #定位到第一个sheet  
    worksheet.Select  
    sheetvalue=worksheet.Range('a2').value #读取a2中的数据
    assert_equal(sheetvalue, "计算机体系结构")
  end

end
