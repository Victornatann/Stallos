unit uUtils;

interface

uses
  System.Classes, System.JSON, FireDAC.Comp.Client, Data.DBXPlatform, uDm;

function messageError(Value: String): TJSONObject;
function messageSucess(Value: String): TJSONObject;
function PrepareQuery(Value: String): TFDQuery;
procedure FormatJson(const Status_Code: Integer; const AContent: String);
function NextId(table, chave : String): Integer;

implementation

function NextId(table, chave: String): Integer;
var
  Query: TFDQuery;
begin
  try
      Query := PrepareQuery('SELECT (coalesce(max(' + chave +'),0)+1)  ID from ' + table);
      Query.Open;
      if Query.FieldByName('ID').AsInteger > 0 then
        Result := Query.FieldByName('ID').AsInteger
      else
        Result := 1;
  finally
    Query.Free;
  end;
end;

function messageError(Value: String): TJSONObject;
var
  st: String;
begin
  st := '{"mensagem":"' + Value + '"}';
  Result := TJSONObject.ParseJSONValue(st) as TJSONObject;
end;

function messageSucess(Value: String): TJSONObject;
var
  st: String;
begin
  st := '{"mensagem":"' + Value + '"}';
  Result := TJSONObject.ParseJSONValue(st) as TJSONObject;
end;

function PrepareQuery(Value: String): TFDQuery;
var
  Query: TFDQuery;

begin

  Query := TFDQuery.Create(Nil);
  Query.Connection := DM.Conn;
  Query.SQL.Text := Value;
  Result := Query;
end;

procedure FormatJson(const Status_Code: Integer; const AContent: String);
begin
  GetInvocationMetadata().ResponseCode := Status_Code;
  GetInvocationMetadata().ResponseContent := AContent;
end;

end.
