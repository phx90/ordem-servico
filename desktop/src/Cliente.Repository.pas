unit Cliente.Repository;

interface

type
  TCliente = record
    Id: Integer;
    Nome: string;
    Telefone: string;
    Email: string;
    function EhNovo: Boolean;
    procedure Validar;
  end;

  TClienteRepository = class
  public
    class function Buscar(AId: Integer): TCliente;
    class procedure Salvar(var ACliente: TCliente);
    class procedure Inativar(AId: Integer);
  end;

implementation

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  Conexao.DataModule, Comum.Erros;

{ TCliente }

function TCliente.EhNovo: Boolean;
begin
  Result := Id = 0;
end;

procedure TCliente.Validar;
begin
  if Trim(Nome) = '' then
    raise EValidacao.Create('Informe o nome do cliente.');

  // a consulta web usa os 4 últimos dígitos, então precisa ter pelo menos isso
  if Length(Trim(Telefone)) < 8 then
    raise EValidacao.Create('Informe um telefone válido, com DDD.');
end;

{ TClienteRepository }

class function TClienteRepository.Buscar(AId: Integer): TCliente;
var
  Query: TFDQuery;
begin
  Query := dmConexao.NovaQuery('select id, nome, telefone, email from clientes where id = :id');
  try
    Query.ParamByName('id').AsInteger := AId;
    Query.Open;

    if Query.IsEmpty then
      raise EValidacao.CreateFmt('Cliente %d não encontrado.', [AId]);

    Result.Id := Query.FieldByName('id').AsInteger;
    Result.Nome := Query.FieldByName('nome').AsString;
    Result.Telefone := Query.FieldByName('telefone').AsString;
    Result.Email := Query.FieldByName('email').AsString;
  finally
    Query.Free;
  end;
end;

class procedure TClienteRepository.Salvar(var ACliente: TCliente);
const
  SQL_INSERT =
    'insert into clientes (nome, telefone, email) values (:nome, :telefone, :email) ' +
    'returning id into :id';
  SQL_UPDATE =
    'update clientes set nome = :nome, telefone = :telefone, email = :email where id = :id';
var
  Query: TFDQuery;
begin
  ACliente.Validar;

  Query := dmConexao.NovaQuery(SQL_UPDATE);
  try
    if ACliente.EhNovo then
      Query.SQL.Text := SQL_INSERT;

    Query.ParamByName('nome').AsString := Trim(ACliente.Nome);
    Query.ParamByName('telefone').AsString := Trim(ACliente.Telefone);
    Query.ParamByName('email').AsString := Trim(ACliente.Email);

    Query.ParamByName('id').DataType := ftInteger;
    Query.ParamByName('id').AsInteger := ACliente.Id;
    if ACliente.EhNovo then
      Query.ParamByName('id').ParamType := ptOutput;

    Query.ExecSQL;
    ACliente.Id := Query.ParamByName('id').AsInteger;
  finally
    Query.Free;
  end;
end;

class procedure TClienteRepository.Inativar(AId: Integer);
begin
  dmConexao.Executar('update clientes set ativo = ''N'' where id = :id', [AId]);
end;

end.
