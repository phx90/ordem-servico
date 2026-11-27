object frmDiagnostico: TfrmDiagnostico
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Diagn'#243'stico'
  ClientHeight = 320
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object lblDiagnostico: TLabel
    Left = 16
    Top = 16
    Width = 223
    Height = 15
    Caption = 'O que foi encontrado / o que ser'#225' feito'
  end
  object lblServico: TLabel
    Left = 16
    Top = 184
    Width = 94
    Height = 15
    Caption = 'M'#227'o de obra (R$)'
  end
  object lblPecas: TLabel
    Left = 172
    Top = 184
    Width = 62
    Height = 15
    Caption = 'Pe'#231'as (R$)'
  end
  object mmoDiagnostico: TMemo
    Left = 16
    Top = 34
    Width = 388
    Height = 136
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object edtServico: TEdit
    Left = 16
    Top = 202
    Width = 140
    Height = 23
    TabOrder = 1
  end
  object edtPecas: TEdit
    Left = 172
    Top = 202
    Width = 140
    Height = 23
    TabOrder = 2
  end
  object btnSalvar: TButton
    Left = 228
    Top = 272
    Width = 84
    Height = 32
    Caption = 'Salvar'
    Default = True
    TabOrder = 3
    OnClick = btnSalvarClick
  end
  object btnFechar: TButton
    Left = 320
    Top = 272
    Width = 84
    Height = 32
    Cancel = True
    Caption = 'Fechar'
    ModalResult = 2
    TabOrder = 4
  end
end
