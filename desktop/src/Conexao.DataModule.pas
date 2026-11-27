unit Conexao.DataModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.Oracle, FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdmConexao = class(TDataModule)
    Conexao: TFDConnection;
    OracleDriver: TFDPhysOracleDriverLink;
    WaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  public
    function NovaQuery(const ASql: string): TFDQuery;
    procedure Executar(const ASql: string; const AParams: array of Variant);
  end;

var
  dmConexao: TdmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Conexao.Config;

procedure TdmConexao.DataModuleCreate(Sender: TObject);
var
  Config: TConfigBanco;
begin
  Config := TConfigBanco.Carregar;

  Conexao.Params.Clear;
  Conexao.Params.Add('DriverID=Ora');
  Conexao.Params.Add('CharacterSet=UTF8');
  Conexao.Params.Database := Config.StringConexao;
  Conexao.Params.UserName := Config.Usuario;
  Conexao.Params.Password := Config.Senha;
  Conexao.Connected := True;
end;

function TdmConexao.NovaQuery(const ASql: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := Conexao;
  Result.SQL.Text := ASql;
end;

procedure TdmConexao.Executar(const ASql: string; const AParams: array of Variant);
begin
  Conexao.ExecSQL(ASql, AParams);
end;

end.
