object frmNovaOS: TfrmNovaOS
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nova ordem de servi'#231'o'
  ClientHeight = 400
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblCliente: TLabel
    Left = 16
    Top = 16
    Width = 39
    Height = 15
    Caption = 'Cliente'
  end
  object lblEquipamento: TLabel
    Left = 16
    Top = 70
    Width = 72
    Height = 15
    Caption = 'Equipamento'
  end
  object lblSerie: TLabel
    Left = 16
    Top = 124
    Width = 90
    Height = 15
    Caption = 'N'#250'mero de s'#233'rie'
  end
  object lblDefeito: TLabel
    Left = 16
    Top = 178
    Width = 88
    Height = 15
    Caption = 'Defeito relatado'
  end
  object cbCliente: TComboBox
    Left = 16
    Top = 34
    Width = 388
    Height = 23
    Style = csDropDownList
    TabOrder = 0
  end
  object edtEquipamento: TEdit
    Left = 16
    Top = 88
    Width = 388
    Height = 23
    TabOrder = 1
  end
  object edtSerie: TEdit
    Left = 16
    Top = 142
    Width = 200
    Height = 23
    TabOrder = 2
  end
  object mmoDefeito: TMemo
    Left = 16
    Top = 196
    Width = 388
    Height = 100
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object chkPrevisao: TCheckBox
    Left = 16
    Top = 312
    Width = 150
    Height = 17
    Caption = 'Previs'#227'o de entrega'
    TabOrder = 4
    OnClick = chkPrevisaoClick
  end
  object dtpPrevisao: TDateTimePicker
    Left = 172
    Top = 308
    Width = 120
    Height = 23
    Date = 46353.000000000000000000
    Time = 46353.000000000000000000
    TabOrder = 5
  end
  object btnAbrir: TButton
    Left = 228
    Top = 352
    Width = 84
    Height = 32
    Caption = 'Abrir OS'
    Default = True
    TabOrder = 6
    OnClick = btnAbrirClick
  end
  object btnFechar: TButton
    Left = 320
    Top = 352
    Width = 84
    Height = 32
    Cancel = True
    Caption = 'Fechar'
    ModalResult = 2
    TabOrder = 7
  end
end
