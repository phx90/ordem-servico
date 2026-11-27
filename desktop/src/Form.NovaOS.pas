unit Form.NovaOS;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TfrmNovaOS = class(TForm)
    lblCliente: TLabel;
    cbCliente: TComboBox;
    lblEquipamento: TLabel;
    edtEquipamento: TEdit;
    lblSerie: TLabel;
    edtSerie: TEdit;
    lblDefeito: TLabel;
    mmoDefeito: TMemo;
    chkPrevisao: TCheckBox;
    dtpPrevisao: TDateTimePicker;
    btnAbrir: TButton;
    btnFechar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure chkPrevisaoClick(Sender: TObject);
    procedure btnAbrirClick(Sender: TObject);
  private
    FOsAberta: Integer;
  public
    /// Mostra a tela e devolve o número da OS aberta (0 se desistiu).
    class function Executar: Integer;
  end;

implementation

{$R *.dfm}

uses
  Comum.Tela, OrdemServico.Service;

class function TfrmNovaOS.Executar: Integer;
var
  Form: TfrmNovaOS;
begin
  Form := TfrmNovaOS.Create(nil);
  try
    Form.ShowModal;
    Result := Form.FOsAberta;
  finally
    Form.Free;
  end;
end;

procedure TfrmNovaOS.FormCreate(Sender: TObject);
begin
  CarregarCombo(cbCliente, 'select id, nome from clientes where ativo = ''S'' order by nome');
  dtpPrevisao.Date := Date + 3;
  chkPrevisaoClick(nil);
end;

procedure TfrmNovaOS.chkPrevisaoClick(Sender: TObject);
begin
  dtpPrevisao.Enabled := chkPrevisao.Checked;
end;

procedure TfrmNovaOS.btnAbrirClick(Sender: TObject);
var
  OS: TNovaOS;
begin
  OS.ClienteId := IdSelecionado(cbCliente);
  OS.Equipamento := edtEquipamento.Text;
  OS.NumeroSerie := edtSerie.Text;
  OS.Defeito := mmoDefeito.Lines.Text;
  OS.TemPrevisao := chkPrevisao.Checked;
  OS.Previsao := dtpPrevisao.Date;

  FOsAberta := TOrdemServicoService.Abrir(OS);
  ModalResult := mrOk;
end;

end.
