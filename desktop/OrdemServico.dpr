program OrdemServico;

uses
  Vcl.Forms,
  Conexao.Config in 'src\Conexao.Config.pas',
  Conexao.DataModule in 'src\Conexao.DataModule.pas' {dmConexao: TDataModule},
  Comum.Erros in 'src\Comum.Erros.pas',
  Comum.Tela in 'src\Comum.Tela.pas',
  Cliente.Repository in 'src\Cliente.Repository.pas',
  OrdemServico.Service in 'src\OrdemServico.Service.pas',
  Form.Principal in 'src\Form.Principal.pas' {frmPrincipal},
  Form.Clientes in 'src\Form.Clientes.pas' {frmClientes},
  Form.NovaOS in 'src\Form.NovaOS.pas' {frmNovaOS},
  Form.Diagnostico in 'src\Form.Diagnostico.pas' {frmDiagnostico},
  Form.EscolherTecnico in 'src\Form.EscolherTecnico.pas' {frmEscolherTecnico};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Ordens de Serviço';
  Application.CreateForm(TdmConexao, dmConexao);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
