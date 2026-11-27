unit Comum.Tela;

{ Pequenos helpers usados pelas telas }

interface

uses
  Vcl.StdCtrls;

/// Preenche um combo com o resultado de um select "id, descricao".
procedure CarregarCombo(ACombo: TComboBox; const ASql: string);

/// Id do item selecionado no combo, ou 0 se nada estiver selecionado.
function IdSelecionado(ACombo: TComboBox): Integer;

/// Converte o texto de um campo de valor (aceita "1.234,56" ou vazio = 0).
function TextoParaValor(const ATexto, ACampo: string): Currency;

implementation

uses
  System.SysUtils, FireDAC.Comp.Client, Conexao.DataModule, Comum.Erros;

procedure CarregarCombo(ACombo: TComboBox; const ASql: string);
var
  Query: TFDQuery;
begin
  ACombo.Items.Clear;

  Query := dmConexao.NovaQuery(ASql);
  try
    Query.Open;
    while not Query.Eof do
    begin
      ACombo.Items.AddObject(Query.Fields[1].AsString, TObject(NativeInt(Query.Fields[0].AsInteger)));
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function IdSelecionado(ACombo: TComboBox): Integer;
begin
  Result := 0;
  if ACombo.ItemIndex < 0 then
    Exit;

  Result := Integer(NativeInt(ACombo.Items.Objects[ACombo.ItemIndex]));
end;

function TextoParaValor(const ATexto, ACampo: string): Currency;
var
  Limpo: string;
begin
  Limpo := Trim(StringReplace(ATexto, '.', '', [rfReplaceAll]));
  if Limpo = '' then
    Exit(0);

  if not TryStrToCurr(Limpo, Result, TFormatSettings.Create('pt-BR')) then
    raise EValidacao.CreateFmt('%s: "%s" não é um valor válido.', [ACampo, ATexto]);
end;

end.
