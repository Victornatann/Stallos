object SMService: TSMService
  OldCreateOrder = False
  Height = 205
  Width = 156
  object FDQueryDepartment: TFDQuery
    SQL.Strings = (
      'select * from department where DEPT_NO = :DEPT')
    Left = 56
    Top = 48
    ParamData = <
      item
        Name = 'DEPT'
        DataType = ftString
        ParamType = ptInput
      end>
  end
  object FDQueryDepartmentEmployees: TFDQuery
    SQL.Strings = (
      'select * from employee where dept_no = :DEPT')
    Left = 56
    Top = 112
    ParamData = <
      item
        Name = 'DEPT'
        DataType = ftString
        ParamType = ptInput
      end>
  end
end
