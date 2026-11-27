object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Ordens de Servi'#231'o'
  ClientHeight = 560
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  TextHeight = 15
  object pnlFiltro: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblStatus: TLabel
      Left = 12
      Top = 15
      Width = 35
      Height = 15
      Caption = 'Status:'
    end
    object lblBusca: TLabel
      Left = 228
      Top = 15
      Width = 120
      Height = 15
      Caption = 'Cliente / equipamento:'
    end
    object cbStatus: TComboBox
      Left = 56
      Top = 11
      Width = 150
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbStatusChange
    end
    object edtBusca: TEdit
      Left = 356
      Top = 11
      Width = 250
      Height = 23
      TabOrder = 1
      OnKeyPress = edtBuscaKeyPress
    end
    object btnAtualizar: TButton
      Left = 614
      Top = 8
      Width = 90
      Height = 30
      Caption = 'Atualizar'
      TabOrder = 2
      OnClick = btnAtualizarClick
    end
    object btnClientes: TButton
      Left = 890
      Top = 8
      Width = 100
      Height = 30
      Anchors = [akTop, akRight]
      Caption = 'Clientes'
      TabOrder = 3
      OnClick = btnClientesClick
    end
  end
  object pnlAcoes: TPanel
    Left = 0
    Top = 45
    Width = 1000
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btnNovaOS: TButton
      Left = 12
      Top = 6
      Width = 100
      Height = 32
      Caption = 'Nova OS'
      TabOrder = 0
      OnClick = btnNovaOSClick
    end
    object btnIniciar: TButton
      Left = 128
      Top = 6
      Width = 100
      Height = 32
      Caption = 'Iniciar'
      TabOrder = 1
      OnClick = btnIniciarClick
    end
    object btnDiagnostico: TButton
      Left = 234
      Top = 6
      Width = 100
      Height = 32
      Caption = 'Diagn'#243'stico'
      TabOrder = 2
      OnClick = btnDiagnosticoClick
    end
    object btnConcluir: TButton
      Left = 340
      Top = 6
      Width = 100
      Height = 32
      Caption = 'Concluir'
      TabOrder = 3
      OnClick = btnConcluirClick
    end
    object btnEntregar: TButton
      Left = 446
      Top = 6
      Width = 100
      Height = 32
      Caption = 'Entregar'
      TabOrder = 4
      OnClick = btnEntregarClick
    end
    object btnCancelar: TButton
      Left = 562
      Top = 6
      Width = 100
      Height = 32
      Caption = 'Cancelar OS'
      TabOrder = 5
      OnClick = btnCancelarClick
    end
  end
  object grdOS: TDBGrid
    Left = 0
    Top = 90
    Width = 1000
    Height = 451
    Align = alClient
    DataSource = dsOS
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object stbRodape: TStatusBar
    Left = 0
    Top = 541
    Width = 1000
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object qryOS: TFDQuery
    Left = 48
    Top = 200
  end
  object dsOS: TDataSource
    DataSet = qryOS
    OnDataChange = dsOSDataChange
    Left = 128
    Top = 200
  end
end
