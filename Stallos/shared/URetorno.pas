unit URetorno;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, REST.Client,
  ULibraryScanntech;

type
  TRetorno = class(TObject)
  private
    FRetornoOK: Boolean;
    FStatusEnvio: TStatusEnvio;
    FStatusCode: Integer;
    FStatusText: String;
    FErrorMessage: String;
    FContent: String;

    class var FInstancia: TRetorno;
    procedure Clear;
  public
    class function getInstancia: TRetorno;
    procedure TratarRetorno(Response: TRESTResponse;
      MensagemRetorno: String = '');

    property RetornoOK: Boolean read FRetornoOK;
    property StatusEnvio: TStatusEnvio read FStatusEnvio;
    property StatusCode: Integer read FStatusCode;
    property StatusText: String read FStatusText;
    property ErrorMessage: String read FErrorMessage;
    property Content: String read FContent;
  end;

implementation

{ TRetornoScanntech }

procedure TRetorno.Clear;
begin
  FRetornoOK := False;
  FStatusEnvio := seErro;
  FStatusCode := 0;
  FStatusText := EmptyStr;
  FContent := EmptyStr;
end;

class function TRetorno.getInstancia: TRetorno;
begin
  if FInstancia = nil then
    FInstancia := TRetorno.Create;

  Result := FInstancia;
end;

procedure TRetorno.TratarRetorno(Response: TRESTResponse;
  MensagemRetorno: String);
begin
  Clear;

  if Response <> Nil then
  begin
    FStatusCode := Response.StatusCode;
    FStatusText := Response.StatusText;
    FContent := Response.Content;
    FErrorMessage := Response.ErrorMessage;

    if FStatusCode in [200, 208] then
    begin
      FRetornoOK := True;
      FStatusEnvio := seEnviado
    end
    else
    begin
      FRetornoOK := False;

      if (FStatusCode = 408) or ((FStatusCode >= 500) and (FStatusCode <= 599))
      then
        FStatusEnvio := sePendente
      else
        FStatusEnvio := seErro;
    end;
  end
  else
  begin
    FStatusCode := -999;
    FStatusText := MensagemRetorno;
    FContent := MensagemRetorno;
    FErrorMessage := MensagemRetorno;
    FRetornoOK := False;
    FStatusEnvio := seErro;
  end;
end;

end.
