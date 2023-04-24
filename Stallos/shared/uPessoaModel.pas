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
    FDsCep: String;
    procedure SetIdPessoa(const Value: Integer);
    procedure SetDsDocumento(const Value: String);
    procedure SetDtRegisto(const Value: TDate);
    procedure SetFlNatureza(const Value: Integer);
    procedure SetNmPrimeiro(const Value: String);
    procedure SetNmSegundo(const Value: String);
    procedure SetDsCep(const Value: String);

  public

    property IdPessoa: Integer read FIdPessoa write SetIdPessoa;
    property FlNatureza: Integer read FFlNatureza write SetFlNatureza;
    property DsDocumento: String read FDsDocumento write SetDsDocumento;
    property NmPrimeiro: String read FNmPrimeiro write SetNmPrimeiro;
    property NmSegundo: String read FNmSegundo write SetNmSegundo;
    property DtRegisto: TDate read FDtRegisto write SetDtRegisto;
    property DsCep: String read FDsCep write SetDsCep;

    property JSON: String read FJSON;
    function toJSON: String;

  end;

type
  TPessoas = class(TObject)
  private
    FPessoaList: TList<TPessoaModel>;
    procedure SetPessoaList(const Value: TList<TPessoaModel>);

  public
    property PessoaList: TList<TPessoaModel> read FPessoaList
      write SetPessoaList;
    procedure FromJSON(AJSON: String);
    constructor create;

  end;

implementation

uses
  System.JSON;

{ TClienteModel }

procedure TPessoaModel.SetDsCep(const Value: String);
begin
  FDsCep := Value;
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
  AddTextJSON('"DsCep":"' + DsCep + '",');
  AddTextJSON('"NmSegundo":"' + NmSegundo + '"');

  AddTextJSON('}');

  FJSON := sJSON;
  Result := sJSON;
end;

{ TPessoas }

constructor TPessoas.create;
begin
  PessoaList := TList<TPessoaModel>.create;
end;

procedure TPessoas.FromJSON(AJSON: String);
var
  I: Integer;
  JSONObject: TJSONObject;
  JSONArray: TJSONArray;
  Pessoa: TPessoaModel;

begin

  JSONArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AJSON), 0)
    as TJSONArray;
  Pessoa := TPessoaModel.create;


  for I := 0 to JSONArray.Count - 1 do
  begin
    JSONObject := JSONArray.Items[I] as TJSONObject;
    with Pessoa do
    begin
      IdPessoa := StrToIntDef((JSONObject.Get('IdPessoa').JSONValue).Value, 0);
      FlNatureza := StrToIntDef((JSONObject.Get('FlNatureza').JSONValue)
        .Value, 0);
      DsDocumento := (JSONObject.Get('DsDocumento').JSONValue).Value;
      NmPrimeiro := (JSONObject.Get('NmPrimeiro').JSONValue).Value;
      NmSegundo := (JSONObject.Get('NmSegundo').JSONValue).Value;
    end;

    PessoaList.Add(Pessoa);
  end;

end;

procedure TPessoas.SetPessoaList(const Value: TList<TPessoaModel>);
begin
  FPessoaList := Value;
end;

end.
