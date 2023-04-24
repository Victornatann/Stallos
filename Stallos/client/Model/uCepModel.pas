unit uCepModel;

interface

type
  TCepModel = class(TObject)
  private
    FLogradouro: string;
    FBairro: string;
    FUF: string;
    FCEP: string;
    FLocalidade: string;
    procedure SetBairro(const Value: string);
    procedure SetCEP(const Value: string);
    procedure SetLocalidade(const Value: string);
    procedure SetLogradouro(const Value: string);
    procedure SetUF(const Value: string);
  public
    property CEP: string read FCEP write SetCEP;
    property Logradouro: string read FLogradouro write SetLogradouro;
    property Bairro: string read FBairro write SetBairro;
    property Localidade: string read FLocalidade write SetLocalidade;
    property UF: string read FUF write SetUF;
  end;

implementation

{ TCep }

procedure TCepModel.SetBairro(const Value: string);
begin
  FBairro := Value;
end;

procedure TCepModel.SetCEP(const Value: string);
begin
  FCEP := Value;
end;

procedure TCepModel.SetLocalidade(const Value: string);
begin
  FLocalidade := Value;
end;

procedure TCepModel.SetLogradouro(const Value: string);
begin
  FLogradouro := Value;
end;

procedure TCepModel.SetUF(const Value: string);
begin
  FUF := Value;
end;

end.
