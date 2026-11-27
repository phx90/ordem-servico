object frmClientes: TfrmClientes
  Left = 0
  Top = 0
  Caption = 'Clientes'
  ClientHeight = 440
  ClientWidth = 820
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlBusca: TPanel
    Left = 0
    Top = 0
    Width = 820
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblBusca: TLabel
      Left = 12
      Top = 15
      Width = 40
      Height = 15
      Caption = 'Buscar:'
    end
    object edtBusca: TEdit
      Left = 60
      Top = 11
      Width = 300
      Height = 23
      TabOrder = 0
    end
    object btnBuscar: TButton
      Left = 368
      Top = 8
      Width = 84
      Height = 30
      Caption = 'Buscar'
      Default = True
      TabOrder = 1
      OnClick = btnBuscarClick
    end
  end
  object pnlEdicao: TPanel
    Left = 520
    Top = 45
    Width = 300
    Height = 395
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object lblNome: TLabel
      Left = 16
      Top = 16
      Width = 268
      Height = 15
      Caption = 'Nome'
    end
    object edtNome: TEdit
      Left = 16
      Top = 34
      Width = 268
      Height = 23
      TabOrder = 0
    end
    object lblTelefone: TLabel
      Left = 16
      Top = 68
      Width = 268
      Height = 15
      Caption = 'Telefone (com DDD)'
    end
    object edtTelefone: TEdit
      Left = 16
      Top = 86
      Width = 268
      Height = 23
      TabOrder = 1
    end
    object lblEmail: TLabel
      Left = 16
      Top = 120
      Width = 268
      Height = 15
      Caption = 'E-mail'
    end
    object edtEmail: TEdit
      Left = 16
      Top = 138
      Width = 268
      Height = 23
      TabOrder = 2
    end
    object btnNovo: TButton
      Left = 16
      Top = 180
      Width = 84
      Height = 30
      Caption = 'Novo'
      TabOrder = 3
      OnClick = btnNovoClick
    end
    object btnSalvar: TButton
      Left = 108
      Top = 180
      Width = 84
      Height = 30
      Caption = 'Salvar'
      TabOrder = 4
      OnClick = btnSalvarClick
    end
    object btnInativar: TButton
      Left = 200
      Top = 180
      Width = 84
      Height = 30
      Caption = 'Inativar'
      TabOrder = 5
      OnClick = btnInativarClick
    end
  end
  object grdLista: TDBGrid
    Left = 0
    Top = 45
    Width = 520
    Height = 395
    Align = alClient
    DataSource = dsLista
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnCellClick = grdListaCellClick
  end
  object qryLista: TFDQuery
    Left = 40
    Top = 200
  end
  object dsLista: TDataSource
    DataSet = qryLista
    Left = 120
    Top = 200
  end
end
