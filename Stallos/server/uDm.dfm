object DM: TDM
  OldCreateOrder = False
  Height = 150
  Width = 215
  object Conn: TFDConnection
    Params.Strings = (
      'Database=stallos'
      'User_Name=root'
      'Password=root'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 24
    Top = 24
  end
end
