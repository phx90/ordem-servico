object dmConexao: TdmConexao
  OnCreate = DataModuleCreate
  Height = 160
  Width = 320
  object Conexao: TFDConnection
    Params.Strings = (
      'DriverID=Ora')
    LoginPrompt = False
    Left = 40
    Top = 32
  end
  object OracleDriver: TFDPhysOracleDriverLink
    Left = 128
    Top = 32
  end
  object WaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 232
    Top = 32
  end
end
