unit Form.Principal;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmPrincipal = class(TForm)
    pnlFiltro: TPanel;
    lblStatus: TLabel;
    cbStatus: TComboBox;
    lblBusca: TLabel;
    edtBusca: TEdit;
    btnAtualizar: TButton;
    btnClientes: TButton;
    pnlAcoes: TPanel;
    btnNovaOS: TButton;
    btnIniciar: TButton;
    btnDiagnostico: TButton;
    btnConcluir: TButton;
    btnEntregar: TButton;
    btnCancelar: TButton;
    grdOS: TDBGrid;
    stbRodape: TStatusBar;
    qryOS: TFDQuery;
    dsOS: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure cbStatusChange(Sender: TObject);
    procedure edtBuscaKeyPress(Sender: TObject; var Key: Char);
    procedure dsOSDataChange(Sender: TObject; Field: TField);
    procedure btnClientesClick(Sender: TObject);
    procedure btnNovaOSClick(Sender: TObject);
    procedure btnIniciarClick(Sender: TObject);
    procedure btnDiagnosticoClick(Sender: TObject);
    procedure btnConcluirClick(Sender: TObject);
    procedure btnEntregarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    procedure TratarErro(Sender: TObject; E: Exception);
    procedure CarregarLista(AManterOS: Integer = 0);
    procedure AtualizarBotoes;
    function OSAtual: Integer;
    function StatusAtual: string;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  System.UITypes, Conexao.DataModule, Comum.Erros, OrdemServico.Service,
  Form.Clientes, Form.NovaOS, Form.Diagnostico, Form.EscolherTecnico;

const
  TODOS_STATUS = 'Todas';

  SQL_LISTA =
    'select id as "OS", status as "Status", cliente as "Cliente", telefone as "Telefone", ' +
    '       equipamento as "Equipamento", tecnico as "Técnico", aberta_em as "Abertura", ' +
    '       previsao as "Previsão", valor_total as "Total", ' +
    '       diagnostico, valor_servico, valor_pecas ' +
    '  from vw_os ' +
    ' where (:status is null or status = :status) ' +
    '   and (upper(cliente) like upper(:busca) or upper(equipamento) like upper(:busca)) ' +
    ' order by id desc';

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  Application.OnException := TratarErro;

  cbStatus.Items.CommaText := TODOS_STATUS + ',ABERTA,EM_ANDAMENTO,PRONTA,ENTREGUE,CANCELADA';
  cbStatus.ItemIndex := 0;

  qryOS.Connection := dmConexao.Conexao;
  qryOS.SQL.Text := SQL_LISTA;
  CarregarLista;
end;

procedure TfrmPrincipal.TratarErro(Sender: TObject; E: Exception);
begin
  if E is EValidacao then
  begin
    MessageDlg(E.Message, mtWarning, [mbOK], 0);
    Exit;
  end;

  MessageDlg(MensagemAmigavel(E), mtError, [mbOK], 0);
end;

procedure TfrmPrincipal.CarregarLista(AManterOS: Integer);
var
  Status: string;
begin
  Status := cbStatus.Text;
  if Status = TODOS_STATUS then
    Status := '';

  qryOS.Close;
  qryOS.ParamByName('status').DataType := ftString;
  qryOS.ParamByName('status').AsString := Status;
  qryOS.ParamByName('busca').AsString := '%' + Trim(edtBusca.Text) + '%';
  qryOS.Open;

  // campos que só servem pra tela de diagnóstico
  qryOS.FieldByName('diagnostico').Visible := False;
  qryOS.FieldByName('valor_servico').Visible := False;
  qryOS.FieldByName('valor_pecas').Visible := False;
  TNumericField(qryOS.FieldByName('Total')).DisplayFormat := '#,##0.00';

  if AManterOS > 0 then
    qryOS.Locate('OS', AManterOS, []);

  stbRodape.SimpleText := Format('%d ordem(ns) de serviço', [qryOS.RecordCount]);
  AtualizarBotoes;
end;

function TfrmPrincipal.OSAtual: Integer;
begin
  Result := 0;
  if qryOS.IsEmpty then
    Exit;

  Result := qryOS.FieldByName('OS').AsInteger;
end;

function TfrmPrincipal.StatusAtual: string;
begin
  Result := '';
  if qryOS.IsEmpty then
    Exit;

  Result := qryOS.FieldByName('Status').AsString;
end;

procedure TfrmPrincipal.AtualizarBotoes;
var
  Status: string;
begin
  // a regra de verdade está na pkg_os; aqui é só pra não oferecer o que não pode
  Status := StatusAtual;
  btnIniciar.Enabled := Status = 'ABERTA';
  btnDiagnostico.Enabled := Status = 'EM_ANDAMENTO';
  btnConcluir.Enabled := Status = 'EM_ANDAMENTO';
  btnEntregar.Enabled := Status = 'PRONTA';
  btnCancelar.Enabled := (Status = 'ABERTA') or (Status = 'EM_ANDAMENTO');
end;

procedure TfrmPrincipal.dsOSDataChange(Sender: TObject; Field: TField);
begin
  AtualizarBotoes;
end;

procedure TfrmPrincipal.btnAtualizarClick(Sender: TObject);
begin
  CarregarLista(OSAtual);
end;

procedure TfrmPrincipal.cbStatusChange(Sender: TObject);
begin
  CarregarLista;
end;

procedure TfrmPrincipal.edtBuscaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then
    Exit;

  Key := #0;
  CarregarLista;
end;

procedure TfrmPrincipal.btnClientesClick(Sender: TObject);
begin
  TfrmClientes.Abrir;
end;

procedure TfrmPrincipal.btnNovaOSClick(Sender: TObject);
var
  NovaOS: Integer;
begin
  NovaOS := TfrmNovaOS.Executar;
  if NovaOS = 0 then
    Exit;

  CarregarLista(NovaOS);
  MessageDlg(Format('OS %d aberta.', [NovaOS]), mtInformation, [mbOK], 0);
end;

procedure TfrmPrincipal.btnIniciarClick(Sender: TObject);
var
  TecnicoId: Integer;
begin
  if not TfrmEscolherTecnico.Escolher(TecnicoId) then
    Exit;

  TOrdemServicoService.Iniciar(OSAtual, TecnicoId);
  CarregarLista(OSAtual);
end;

procedure TfrmPrincipal.btnDiagnosticoClick(Sender: TObject);
var
  Dados: TDadosDiagnostico;
begin
  Dados.OsId := OSAtual;
  Dados.Diagnostico := qryOS.FieldByName('diagnostico').AsString;
  Dados.ValorServico := qryOS.FieldByName('valor_servico').AsCurrency;
  Dados.ValorPecas := qryOS.FieldByName('valor_pecas').AsCurrency;

  if not TfrmDiagnostico.Executar(Dados) then
    Exit;

  CarregarLista(Dados.OsId);
end;

procedure TfrmPrincipal.btnConcluirClick(Sender: TObject);
begin
  TOrdemServicoService.Concluir(OSAtual);
  CarregarLista(OSAtual);
end;

procedure TfrmPrincipal.btnEntregarClick(Sender: TObject);
var
  Pergunta: string;
begin
  Pergunta := Format('Entregar a OS %d para %s?' + sLineBreak + 'Total a receber: R$ %s',
    [OSAtual, qryOS.FieldByName('Cliente').AsString,
     FormatFloat('#,##0.00', qryOS.FieldByName('Total').AsCurrency)]);

  if MessageDlg(Pergunta, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  TOrdemServicoService.Entregar(OSAtual);
  CarregarLista(OSAtual);
end;

procedure TfrmPrincipal.btnCancelarClick(Sender: TObject);
var
  Motivo: string;
begin
  if not InputQuery('Cancelar OS ' + OSAtual.ToString, 'Motivo do cancelamento:', Motivo) then
    Exit;

  TOrdemServicoService.Cancelar(OSAtual, Motivo);
  CarregarLista(OSAtual);
end;

end.
