unit OrdemServico.Service;

{ Só repassa as chamadas para a pkg_os. As regras ficam todas no banco. }

interface

type
  TNovaOS = record
    ClienteId: Integer;
    Equipamento: string;
    NumeroSerie: string;
    Defeito: string;
    TemPrevisao: Boolean;
    Previsao: TDate;
  end;

  TOrdemServicoService = class
  public
    class function Abrir(const AOS: TNovaOS): Integer;
    class procedure Iniciar(AOsId, ATecnicoId: Integer);
    class procedure RegistrarDiagnostico(AOsId: Integer; const ADiagnostico: string;
      AValorServico, AValorPecas: Currency);
    class procedure Concluir(AOsId: Integer);
    class procedure Entregar(AOsId: Integer);
    class procedure Cancelar(AOsId: Integer; const AMotivo: string);
  end;

implementation

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  Conexao.DataModule, Comum.Erros;

class function TOrdemServicoService.Abrir(const AOS: TNovaOS): Integer;
var
  Query: TFDQuery;
begin
  if AOS.ClienteId = 0 then
    raise EValidacao.Create('Escolha o cliente.');

  Query := dmConexao.NovaQuery(
    'begin :id := pkg_os.abrir(:cliente, :equipamento, :defeito, :serie, :previsao); end;');
  try
    Query.ParamByName('id').DataType := ftInteger;
    Query.ParamByName('id').ParamType := ptOutput;
    Query.ParamByName('cliente').AsInteger := AOS.ClienteId;
    Query.ParamByName('equipamento').AsString := AOS.Equipamento;
    Query.ParamByName('defeito').AsString := AOS.Defeito;
    Query.ParamByName('serie').AsString := AOS.NumeroSerie;

    Query.ParamByName('previsao').DataType := ftDate;
    Query.ParamByName('previsao').Clear;
    if AOS.TemPrevisao then
      Query.ParamByName('previsao').AsDate := AOS.Previsao;

    Query.ExecSQL;
    Result := Query.ParamByName('id').AsInteger;
  finally
    Query.Free;
  end;
end;

class procedure TOrdemServicoService.Iniciar(AOsId, ATecnicoId: Integer);
begin
  if ATecnicoId = 0 then
    raise EValidacao.Create('Escolha o técnico.');

  dmConexao.Executar('begin pkg_os.iniciar(:os, :tecnico); end;', [AOsId, ATecnicoId]);
end;

class procedure TOrdemServicoService.RegistrarDiagnostico(AOsId: Integer;
  const ADiagnostico: string; AValorServico, AValorPecas: Currency);
begin
  dmConexao.Executar(
    'begin pkg_os.registrar_diagnostico(:os, :diagnostico, :servico, :pecas); end;',
    [AOsId, ADiagnostico, AValorServico, AValorPecas]);
end;

class procedure TOrdemServicoService.Concluir(AOsId: Integer);
begin
  dmConexao.Executar('begin pkg_os.concluir(:os); end;', [AOsId]);
end;

class procedure TOrdemServicoService.Entregar(AOsId: Integer);
begin
  dmConexao.Executar('begin pkg_os.entregar(:os); end;', [AOsId]);
end;

class procedure TOrdemServicoService.Cancelar(AOsId: Integer; const AMotivo: string);
begin
  dmConexao.Executar('begin pkg_os.cancelar(:os, :motivo); end;', [AOsId, AMotivo]);
end;

end.
