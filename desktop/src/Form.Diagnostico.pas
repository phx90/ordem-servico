unit Form.Diagnostico;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls;

type
  TDadosDiagnostico = record
    OsId: Integer;
    Diagnostico: string;
    ValorServico: Currency;
    ValorPecas: Currency;
  end;

  TfrmDiagnostico = class(TForm)
    lblDiagnostico: TLabel;
    mmoDiagnostico: TMemo;
    lblServico: TLabel;
    edtServico: TEdit;
    lblPecas: TLabel;
    edtPecas: TEdit;
    btnSalvar: TButton;
    btnFechar: TButton;
    procedure btnSalvarClick(Sender: TObject);
  private
    FOsId: Integer;
    procedure Preencher(const ADados: TDadosDiagnostico);
  public
    class function Executar(const ADados: TDadosDiagnostico): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Comum.Tela, OrdemServico.Service;

class function TfrmDiagnostico.Executar(const ADados: TDadosDiagnostico): Boolean;
var
  Form: TfrmDiagnostico;
begin
  Form := TfrmDiagnostico.Create(nil);
  try
    Form.Preencher(ADados);
    Result := Form.ShowModal = mrOk;
  finally
    Form.Free;
  end;
end;

procedure TfrmDiagnostico.Preencher(const ADados: TDadosDiagnostico);
begin
  FOsId := ADados.OsId;
  Caption := Format('Diagnóstico da OS %d', [FOsId]);
  mmoDiagnostico.Lines.Text := ADados.Diagnostico;
  edtServico.Text := FormatFloat('0.00', ADados.ValorServico);
  edtPecas.Text := FormatFloat('0.00', ADados.ValorPecas);
end;

procedure TfrmDiagnostico.btnSalvarClick(Sender: TObject);
begin
  TOrdemServicoService.RegistrarDiagnostico(FOsId,
    mmoDiagnostico.Lines.Text,
    TextoParaValor(edtServico.Text, 'Valor do serviço'),
    TextoParaValor(edtPecas.Text, 'Valor das peças'));

  ModalResult := mrOk;
end;

end.
