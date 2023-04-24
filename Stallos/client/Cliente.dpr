program Cliente;

uses
  Vcl.Forms,
  uPessoa in 'uPessoa.pas' {FrmPessoa},
  uCepModel in 'Model\uCepModel.pas',
  uCustomApi in '..\shared\uCustomApi.pas',
  uDmClient in 'uDmClient.pas' {DMClient: TDataModule},
  URetorno in '..\shared\URetorno.pas',
  uPessoaModel in '..\shared\uPessoaModel.pas',
  uEnderecoModel in '..\shared\uEnderecoModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPessoa, FrmPessoa);
  Application.CreateForm(TDMClient, DMClient);
  Application.Run;
end.
