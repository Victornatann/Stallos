unit uEnderecoModel;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TEnderecoModel = class(TObject)
  private
    FNmCidade: String;
    FNmLogradouro: String;
    FNmBairro: String;
    FDsUf: String;
    FDsCep: String;
    FDsComplemento: String;
    FJSON: String;

    procedure SetDsCep(const Value: String);
    procedure SetDsComplemento(const Value: String);
    procedure SetDsUf(const Value: String);
    procedure SetNmBairro(const Value: String);
    procedure SetNmCidade(const Value: String);
    procedure SetNmLogradouro(const Value: String);

  public
    property DsUf: String read FDsUf write SetDsUf;
    property DsCep: String read FDsCep write SetDsCep;
    property NmCidade: String read FNmCidade write SetNmCidade;
    property NmBairro: String read FNmBairro write SetNmBairro;
    property NmLogradouro: String read FNmLogradouro write SetNmLogradouro;
    property DsComplemento: String read FDsComplemento write SetDsComplemento;

    property JSON: String read FJSON;
    function toJSON: String;

  end;

type
  TEnderecos = class(TObject)
  private
    FEnderecoList: TList<TEnderecoModel>;
    procedure SetEnderecoList(const Value: TList<TEnderecoModel>);

  public
    property EnderecoList: TList<TEnderecoModel> read FEnderecoList
      write SetEnderecoList;
    procedure FromJSON(AJSON: String);
    constructor create;

  end;

implementation

uses
  System.JSON;

{ TEnderecoModel }

constructor TEnderecos.create;
begin
  EnderecoList := TList<TEnderecoModel>.create;
end;

procedure TEnderecos.FromJSON(AJSON: String);
var
  I: Integer;
  JSONObject: TJSONObject;
  JSONArray: TJSONArray;
  Endereco: TEnderecoModel;

begin

  JSONArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AJSON), 0)
    as TJSONArray;

  Endereco := TEnderecoModel.create;

  for I := 0 to JSONArray.Count - 1 do
  begin
    JSONObject := JSONArray.Items[I] as TJSONObject;
    with Endereco do
    begin

      DsUf := (JSONObject.Get('DsUf').JsonValue).Value;
      NmLogradouro := (JSONObject.Get('NmLogradouro').JsonValue).Value;
      DsCep := (JSONObject.Get('DsCep').JsonValue).Value;
      NmCidade := (JSONObject.Get('NmCidade').JsonValue).Value;
      NmBairro := (JSONObject.Get('NmBairro').JsonValue).Value;
      DsComplemento := (JSONObject.Get('DsComplemento').JsonValue).Value;

    end;

    EnderecoList.Add(Endereco);
  end;
end;

procedure TEnderecoModel.SetDsCep(const Value: String);
begin
  FDsCep := Value;
end;

procedure TEnderecoModel.SetDsComplemento(const Value: String);
begin
  FDsComplemento := Value;
end;

procedure TEnderecoModel.SetDsUf(const Value: String);
begin
  FDsUf := Value;
end;

procedure TEnderecoModel.SetNmBairro(const Value: String);
begin
  FNmBairro := Value;
end;

procedure TEnderecoModel.SetNmCidade(const Value: String);
begin
  FNmCidade := Value;
end;

procedure TEnderecoModel.SetNmLogradouro(const Value: String);
begin
  FNmLogradouro := Value;
end;

function TEnderecoModel.toJSON: String;
var
  sJSON: String;

  procedure AddTextJSON(Value: String);
  begin
    sJSON := sJSON + Value;
  end;

begin

  AddTextJSON('{');

  AddTextJSON('"DsUf":"' + DsUf + '",');
  AddTextJSON('"DsCep":"' + DsCep + '",');
  AddTextJSON('"NmCidade":"' + NmCidade + '",');
  AddTextJSON('"NmBairro":"' + NmBairro + '",');
  AddTextJSON('"NmLogradouro":"' + NmLogradouro + '",');
  AddTextJSON('"DsComplemento":"' + DsComplemento + '"');

  AddTextJSON('}');

  FJSON := sJSON;
  Result := sJSON;

end;

procedure TEnderecos.SetEnderecoList(const Value: TList<TEnderecoModel>);
begin
  FEnderecoList := Value;
end;

end.
