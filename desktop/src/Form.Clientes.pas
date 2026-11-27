unit Form.Clientes;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Cliente.Repository;

type
  TfrmClientes = class(TForm)
    pnlBusca: TPanel;
    lblBusca: TLabel;
    edtBusca: TEdit;
    btnBuscar: TButton;
    grdLista: TDBGrid;
    pnlEdicao: TPanel;
    lblNome: TLabel;
    edtNome: TEdit;
    lblTelefone: TLabel;
    edtTelefone: TEdit;
    lblEmail: TLabel;
    edtEmail: TEdit;
    btnNovo: TButton;
    btnSalvar: TButton;
    btnInativar: TButton;
    qryLista: TFDQuery;
    dsLista: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnInativarClick(Sender: TObject);
    procedure grdListaCellClick(Column: TColumn);
  private
    FIdAtual: Integer;
    procedure CarregarLista;
    procedure PreencherTela(const ACliente: TCliente);
    procedure LimparTela;
    function LerTela: TCliente;
  public
    class procedure Abrir;
  end;

implementation

{$R *.dfm}

uses
  System.UITypes, Conexao.DataModule;

const
  SQL_LISTA =
    'select id as "ID", nome as "Nome", telefone as "Telefone", email as "E-mail" ' +
    '  from clientes ' +
    ' where ativo = ''S'' ' +
    '   and upper(nome) like upper(:busca) ' +
    ' order by nome';

class procedure TfrmClientes.Abrir;
var
  Form: TfrmClientes;
begin
  Form := TfrmClientes.Create(nil);
  try
    Form.ShowModal;
  finally
    Form.Free;
  end;
end;

procedure TfrmClientes.FormCreate(Sender: TObject);
begin
  qryLista.Connection := dmConexao.Conexao;
  qryLista.SQL.Text := SQL_LISTA;
  CarregarLista;
  LimparTela;
end;

procedure TfrmClientes.CarregarLista;
begin
  qryLista.Close;
  qryLista.ParamByName('busca').AsString := '%' + Trim(edtBusca.Text) + '%';
  qryLista.Open;
end;

procedure TfrmClientes.PreencherTela(const ACliente: TCliente);
begin
  FIdAtual := ACliente.Id;
  edtNome.Text := ACliente.Nome;
  edtTelefone.Text := ACliente.Telefone;
  edtEmail.Text := ACliente.Email;
  btnInativar.Enabled := not ACliente.EhNovo;
end;

procedure TfrmClientes.LimparTela;
begin
  PreencherTela(Default(TCliente));
end;

function TfrmClientes.LerTela: TCliente;
begin
  Result.Id := FIdAtual;
  Result.Nome := edtNome.Text;
  Result.Telefone := edtTelefone.Text;
  Result.Email := edtEmail.Text;
end;

procedure TfrmClientes.grdListaCellClick(Column: TColumn);
begin
  if qryLista.IsEmpty then
    Exit;

  PreencherTela(TClienteRepository.Buscar(qryLista.FieldByName('ID').AsInteger));
end;

procedure TfrmClientes.btnBuscarClick(Sender: TObject);
begin
  CarregarLista;
end;

procedure TfrmClientes.btnNovoClick(Sender: TObject);
begin
  LimparTela;
  edtNome.SetFocus;
end;

procedure TfrmClientes.btnSalvarClick(Sender: TObject);
var
  Cliente: TCliente;
begin
  Cliente := LerTela;
  TClienteRepository.Salvar(Cliente);

  CarregarLista;
  qryLista.Locate('ID', Cliente.Id, []);
  PreencherTela(Cliente);
end;

procedure TfrmClientes.btnInativarClick(Sender: TObject);
begin
  if FIdAtual = 0 then
    Exit;

  if MessageDlg('Inativar o cliente "' + edtNome.Text + '"?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  TClienteRepository.Inativar(FIdAtual);
  CarregarLista;
  LimparTela;
end;

end.
