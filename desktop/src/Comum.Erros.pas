unit Comum.Erros;

interface

uses
  System.SysUtils;

type
  // erro de validação da própria tela, mostrado como aviso e não como erro
  EValidacao = class(Exception);

/// Tira o "ORA-20xxx: " da frente das mensagens que vêm da pkg_os.
/// Qualquer outro erro volta do jeito que veio.
function MensagemAmigavel(E: Exception): string;

implementation

uses
  System.StrUtils;

const
  PREFIXO_ERRO_NEGOCIO = 'ORA-20';

function MensagemAmigavel(E: Exception): string;
var
  Inicio, Fim: Integer;
begin
  Result := E.Message;

  Inicio := Pos(PREFIXO_ERRO_NEGOCIO, Result);
  if Inicio = 0 then
    Exit;

  Inicio := PosEx(': ', Result, Inicio) + 2;
  Fim := PosEx(#10, Result, Inicio);
  if Fim = 0 then
    Fim := Length(Result) + 1;

  Result := Trim(Copy(Result, Inicio, Fim - Inicio));
end;

end.
