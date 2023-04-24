unit uCustomApi;

interface

uses
  System.SysUtils,
  System.Classes,
  REST.Types,
  REST.Client;



type
  TCustomApi = class(TComponent)

  private
    // Componentes de conexão
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTRequestParams: TRESTRequestParameterList;
    FRESTResponse: TRESTResponse;

  public
    function ConsultarPessoas(): Integer;
    constructor Create(AOwner: TComponent); override;

  end;

implementation

{ TCustomApi }

function TCustomApi.ConsultarPessoas: Integer;
begin
  FRESTRequest.Method := rmGET;

  with FRESTRequest do
  begin
    Client := FRESTClient;
    Response := FRESTResponse;
    SynchronizedEvents := False;
  end;

  FRESTClient.BaseURL :=
    'http://localhost:8080/datasnap/rest/TSMService/Pessoa';
  FRESTRequest.Execute;

end;

constructor TCustomApi.Create(AOwner: TComponent);
begin


end;

end.
