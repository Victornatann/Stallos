unit uPessoaModel;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TPessoaModel = class(TObject)
  private
    FIdPessoa: Integer;
    FNmPrimeiro: String;
    FNmSegundo: String;
    FDsDocumento: String;
    FDtRegisto: TDate;
    FFlNatureza: Integer;
    FJSON: String;
    procedure SetIdPessoa(const Value: Integer);
    procedure SetDsDocumento(const Value: String);
    procedure SetDtRegisto(const Value: TDate);
    procedure SetFlNatureza(const Value: Integer);
    procedure SetNmPrimeiro(const Value: String);
    procedure SetNmSegundo(const Value: String);

  public

    property IdPessoa: Integer read FIdPessoa write SetIdPessoa;
    property FlNatureza: Integer read FFlNatureza write SetFlNatureza;
    property DsDocumento: String read FDsDocumento write SetDsDocumento;
    property NmPrimeiro: String read FNmPrimeiro write SetNmPrimeiro;
    property NmSegundo: String read FNmSegundo write SetNmSegundo;
    property DtRegisto: TDate read FDtRegisto write SetDtRegisto;

    property JSON: String read FJSON;
    function toJSON: String;

    function FromJSON(AJSON: String) : TList<TPessoaModel>;

  end;

implementation

uses
  System.JSON;

{ TClienteModel }

function TPessoaModel.FromJSON(AJSON: String): TList<TPessoaModel>;
var
  I: Integer;
  JSONObject: TJSONObject;
  JSONArray: TJSONArray;
  Pessoa: TPessoaModel;
begin

  JSONArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AJSON), 0)
    as TJSONArray;

  Result := TList<TPessoaModel>.Create;
  Pessoa := TPessoaModel.Create;

  for I := 0 to JSONArray.Count - 1 do
  begin
    JSONObject := JSONArray.Items[I] as TJSONObject;
    with Pessoa do
    begin
      IdPessoa := StrToIntDef((JSONObject.Get('IdPessoa').JSONValue).Value, 0);
      FlNatureza := StrToIntDef((JSONObject.Get('FlNatureza').JSONValue).Value, 0);
      DsDocumento := (JSONObject.Get('DsDocumento').JSONValue).Value;
      NmPrimeiro := (JSONObject.Get('NmPrimeiro').JSONValue).Value;
      NmSegundo := (JSONObject.Get('NmSegundo').JSONValue).Value;
      DtRegisto := StrToDateDef((JSONObject.Get('DtRegisto').JSONValue).Value, Now);
    end;

    Result.Add(Pessoa);
  end;

end;

procedure TPessoaModel.SetDsDocumento(const Value: String);
begin
  FDsDocumento := Value;
end;

procedure TPessoaModel.SetDtRegisto(const Value: TDate);
begin
  FDtRegisto := Value;
end;

procedure TPessoaModel.SetFlNatureza(const Value: Integer);
begin
  FFlNatureza := Value;
end;

procedure TPessoaModel.SetIdPessoa(const Value: Integer);
begin
  FIdPessoa := Value;
end;

procedure TPessoaModel.SetNmPrimeiro(const Value: String);
begin
  FNmPrimeiro := Value;
end;

procedure TPessoaModel.SetNmSegundo(const Value: String);
begin
  FNmSegundo := Value;
end;

function TPessoaModel.toJSON: String;
var
  sJSON: String;

  procedure AddTextJSON(Value: String);
  begin
    sJSON := sJSON + Value;
  end;

begin

  AddTextJSON('{');
  AddTextJSON('"IdPessoa":' + IntToStr(IdPessoa) + ',');
  AddTextJSON('"FlNatureza":' + IntToStr(FlNatureza) + ',');
  AddTextJSON('"DsDocumento":"' + DsDocumento + '",');
  AddTextJSON('"NmPrimeiro":"' + NmPrimeiro + '",');
  AddTextJSON('"NmSegundo":"' + NmSegundo + '"');

  AddTextJSON('}');

  FJSON := sJSON;
  Result := sJSON;
end;

end.
