unit ServerMethodsUnit1;

interface

uses
  System.SysUtils, System.Classes, System.Json,
  Web.HttpApp,
  Datasnap.DSHTTPWebBroker,
  Datasnap.DSServer, Datasnap.DSAuth, Datasnap.DSProviderDataModuleAdapter,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageJSON,
  FireDAC.Comp.UI, FireDAC.Phys.IBBase, uPessoaModel,
  Data.DBXPlatform,

  {Namespace para Reflection}
  Data.FireDACJSONReflect, FireDAC.Stan.StorageBin, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, uPessoaController;

type
  TSMService = class(TDSServerModule)
    FDQueryDepartment: TFDQuery;
    FDQueryDepartmentEmployees: TFDQuery;
  private

    { Private declarations }

  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;

    function Pessoa: TJSONValue; { GET }
    function UpdatePessoa: TJSONValue; { POST }
    function AcceptPessoa(const ID_PESSOA: Integer): TJSONValue; { PUT }
    function CancelPessoa(const ID_PESSOA: Integer): TJSONValue; { DELETE }

    function Endereco(const ID_PESSOA: Integer): TJSONValue; { GET }

  end;

var
  SM: TSMService;

implementation

{$R *.dfm}

uses
  System.StrUtils, uUtils;

function TSMService.AcceptPessoa(const ID_PESSOA: Integer): TJSONValue;
begin
  Result := TPessoaController.getInstancia.PutPessoa(ID_PESSOA);
end;

function TSMService.Pessoa: TJSONValue;
begin
  FormatJson(200, TPessoaController.getInstancia.GetPessoas().ToString);
end;

function TSMService.UpdatePessoa: TJSONValue;
begin
  FormatJson(200, TPessoaController.getInstancia.PostPessoa().ToString);
end;

function TSMService.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TSMService.CancelPessoa(const ID_PESSOA: Integer): TJSONValue;
begin
  Result := TPessoaController.getInstancia.DeletePessoa(ID_PESSOA);
end;

function TSMService.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TSMService.Endereco(const ID_PESSOA: Integer): TJSONValue;
begin
 FormatJson(200, TPessoaController.getInstancia.GetEndereco(ID_PESSOA).ToString);
 //Result := TPessoaController.getInstancia.GetEndereco(ID_PESSOA);
end;

end.
