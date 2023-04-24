program Server;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  UnitMain in 'UnitMain.pas' {Form1},
  ServerMethodsUnit1 in 'ServerMethodsUnit1.pas' {SMService: TDSServerModule},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  uUtils in 'Units\uUtils.pas',
  uPessoaController in 'Controllers\uPessoaController.pas',
  uPessoaModel in 'Models\uPessoaModel.pas',
  uDm in 'uDm.pas' {DM: TDataModule},
  uEnderecoModel in '..\shared\uEnderecoModel.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDM, DM);
  Application.Run;

end.
