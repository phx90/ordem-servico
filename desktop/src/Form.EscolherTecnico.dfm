object frmEscolherTecnico: TfrmEscolherTecnico
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Quem vai pegar essa OS?'
  ClientHeight = 130
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblTecnico: TLabel
    Left = 16
    Top = 16
    Width = 44
    Height = 15
    Caption = 'T'#233'cnico'
  end
  object cbTecnico: TComboBox
    Left = 16
    Top = 34
    Width = 288
    Height = 23
    Style = csDropDownList
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 128
    Top = 82
    Width = 84
    Height = 32
    Caption = 'Iniciar'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnFechar: TButton
    Left = 220
    Top = 82
    Width = 84
    Height = 32
    Cancel = True
    Caption = 'Fechar'
    ModalResult = 2
    TabOrder = 2
  end
end
