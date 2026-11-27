unit Form.EscolherTecnico;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls;

type
  TfrmEscolherTecnico = class(TForm)
    lblTecnico: TLabel;
    cbTecnico: TComboBox;
    btnOk: TButton;
    btnFechar: TButton;
    procedure FormCreate(Sender: TObject);
  public
    class function Escolher(out ATecnicoId: Integer): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Comum.Tela;

class function TfrmEscolherTecnico.Escolher(out ATecnicoId: Integer): Boolean;
var
  Form: TfrmEscolherTecnico;
begin
  Form := TfrmEscolherTecnico.Create(nil);
  try
    Result := Form.ShowModal = mrOk;
    ATecnicoId := IdSelecionado(Form.cbTecnico);
  finally
    Form.Free;
  end;
end;

procedure TfrmEscolherTecnico.FormCreate(Sender: TObject);
begin
  CarregarCombo(cbTecnico, 'select id, nome from tecnicos where ativo = ''S'' order by nome');
end;

end.
