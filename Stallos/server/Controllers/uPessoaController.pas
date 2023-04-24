unit uPessoaController;

interface

uses
  System.Json,
  uPessoaModel,
  uEnderecoModel,
  System.SysUtils,
  uUtils,
  Data.DBXPlatform,
  Datasnap.DSHTTPWebBroker,
  Web.HttpApp,
  FireDAC.Comp.Client;

type
  TPessoaController = class
  public

    function GetPessoas(): TJSONValue;
    function PostPessoa(): TJSONValue;
    function PutPessoa(const ID_PESSOA: Integer): TJSONValue;
    function DeletePessoa(const ID_PESSOA: Integer): TJSONValue;

    function GetEndereco(const ID_PESSOA: Integer): TJSONValue;
    class function getInstancia: TPessoaController;
    constructor Create; reintroduce;
  private
    FPessoaModel: TPessoaModel;
    FEnderecoModel: TEnderecoModel;
    class var FInstancia: TPessoaController;

    procedure SetPessoaModel(const Value: TPessoaModel);
    procedure SetEnderecoModel(const Value: TEnderecoModel);
    property PessoaModel: TPessoaModel read FPessoaModel write SetPessoaModel;
    procedure GravaEndereco(iIdPessoa: Integer; sCep: String);
    procedure GravaEnterecoIntegracao(iIdEndereco: Integer);
    property EnderecoModel: TEnderecoModel read FEnderecoModel
      write SetEnderecoModel;

  end;

implementation

{ TPessoaController }

uses ServerMethodsUnit1;

function TPessoaController.PostPessoa(): TJSONValue;
const
  _Sql = 'insert into PESSOA (IDPESSOA, FLNATUREZA, DSDOCUMENTO, NMPRIMEIRO,' +
    ' NMSEGUNDO, DTREGISTRO) values (:pIDPESSOA, :pFLNATUREZA, ' +
    ':pDSDOCUMENTO, :pNMPRIMEIRO, :pNMSEGUNDO, :pDTREGISTRO);';

var
  iModulo: TWebModule;
  lBody: TJSONObject;
  Query: TFDQuery;
  iIdPessoa: Integer;
begin
  iModulo := GetDataSnapWebModule;

  if iModulo.Request.Content.IsEmpty then
  begin
    GetInvocationMetadata().ResponseCode := 204;
    Abort
  end;
  try
    try
      lBody := TJSONObject.ParseJSONValue
        (TEncoding.ASCII.GetBytes(iModulo.Request.Content), 0) as TJSONObject;

      Query := PrepareQuery(_Sql);
      Query.Connection.StartTransaction;
      iIdPessoa := NextId('Pessoa', 'IdPessoa');
      Query.ParamByName('pIDPESSOA').AsInteger := iIdPessoa;
      Query.ParamByName('pFLNATUREZA').AsInteger :=
        lBody.GetValue<Integer>('FlNatureza');
      Query.ParamByName('pDSDOCUMENTO').AsString :=
        lBody.GetValue<string>('DsDocumento');
      Query.ParamByName('pNMPRIMEIRO').AsString :=
        lBody.GetValue<string>('NmPrimeiro');
      Query.ParamByName('pNMSEGUNDO').AsString :=
        lBody.GetValue<string>('NmSegundo');
      Query.ParamByName('pDTREGISTRO').AsDateTime := Date;
      Query.ExecSQL;
      Query.Connection.Commit;

      GravaEndereco(iIdPessoa, lBody.GetValue<string>('DsCep'));
      Result := messageSucess('Pessoa cadastrada com sucesso');

    except
      GetInvocationMetadata().ResponseCode := 500;
      Query.Connection.Rollback;
      Result := messageError('Erro ao inserir o registro');
    end;
  finally
    Query.Free;
  end;

end;

function TPessoaController.PutPessoa(const ID_PESSOA: Integer): TJSONValue;
const
  _Sql = 'update PESSOA     ' + 'set FLNATUREZA = :PFLNATUREZA,  ' +
    '    DSDOCUMENTO = :PDSDOCUMENTO,  ' + '    NMPRIMEIRO = :PNMPRIMEIRO,    '
    + '    NMSEGUNDO = :PNMSEGUNDO,      ' + '    DTREGISTRO = :PDTREGISTRO    '
    + 'where IDPESSOA = :PIDPESSOA';

var
  iModulo: TWebModule;
  lBody: TJSONObject;
  Query: TFDQuery;
begin
  iModulo := GetDataSnapWebModule;

  if iModulo.Request.Content.IsEmpty then
  begin
    GetInvocationMetadata().ResponseCode := 204;
    Abort
  end;

  try
    lBody := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes(iModulo.Request.Content), 0) as TJSONObject;

    Query := PrepareQuery(_Sql);
    Query.ParamByName('pIDPESSOA').AsInteger := ID_PESSOA;
    Query.ParamByName('pFLNATUREZA').AsInteger :=
      lBody.GetValue<Integer>('FLNATUREZA');
    Query.ParamByName('pDSDOCUMENTO').AsString :=
      lBody.GetValue<string>('DSDOCUMENTO');
    Query.ParamByName('pNMPRIMEIRO').AsString :=
      lBody.GetValue<string>('NMPRIMEIRO');
    Query.ParamByName('pNMSEGUNDO').AsString :=
      lBody.GetValue<string>('NMSEGUNDO');
    Query.ParamByName('pDTREGISTRO').AsDateTime := Date;
    Query.ExecSQL;
    Result := messageSucess('Pessoa atualizada com sucesso');
  except
    Result := messageError('Erro ao inserir o registro');
  end;
end;

constructor TPessoaController.Create;
begin
  FPessoaModel := TPessoaModel.Create;
  FEnderecoModel := TEnderecoModel.Create;
end;

function TPessoaController.DeletePessoa(const ID_PESSOA: Integer): TJSONValue;
var
  Query: TFDQuery;
begin
  try
    Query := PrepareQuery('DELETE FROM PESSOA WHERE IDPESSOA = ' +
      IntToStr(ID_PESSOA));
    Query.ExecSQL;
    Result := messageSucess('Registro excluido');
  except
    GetInvocationMetadata().ResponseCode := 500;
    Result := messageError('Erro ao excluir o registro');
  end;
end;

function TPessoaController.GetEndereco(const ID_PESSOA: Integer): TJSONValue;
const
  _Sql = 'SELECT ei.dsuf, e.dscep, ei.nmcidade, ei.nmbairro, ' +
    'ei.nmlogradouro, ei.dscomplemento FROM stallos.endereco e inner join ' +
    ' endereco_integracao ei on (e.idendereco = ei.idendereco and e.idpessoa = :idpessoa)';
var
  Query: TFDQuery;
  JSONEnderecos: TJSONArray;
begin

  Query := PrepareQuery(_Sql);
  Query.ParamByName('idpessoa').AsInteger := ID_PESSOA;
  Query.Open;

  if (Query.IsEmpty) then
  begin
    GetInvocationMetadata().ResponseCode := 500;
    Result := messageError('Nenhum endereço encontrado');
  end
  else
  begin
    JSONEnderecos := TJSONArray.Create;

    while not Query.EOF do
    begin

      with Query, EnderecoModel do
      begin

        dsuf := FieldByName('dsuf').AsString;
        dscep := FieldByName('dscep').AsString;
        nmcidade := FieldByName('nmcidade').AsString;
        nmbairro := FieldByName('nmbairro').AsString;
        nmlogradouro := FieldByName('nmlogradouro').AsString;
        dscomplemento := FieldByName('dscomplemento').AsString;
      end;
      JSONEnderecos.addElement
        (TJSONObject.ParseJSONValue(EnderecoModel.ToJson));
      Query.Next;
    end;

    Result := JSONEnderecos;

  end;

end;

class function TPessoaController.getInstancia: TPessoaController;
begin
  if not Assigned(FInstancia) then
    FInstancia := TPessoaController.Create;

  Result := FInstancia;
end;

function TPessoaController.GetPessoas: TJSONValue;
const
  _Sql = 'select * from pessoa';
var
  Query: TFDQuery;
  JSONPessoas: TJSONArray;
begin

  Query := PrepareQuery(_Sql);
  Query.Open;

  if (Query.IsEmpty) then
    Result := messageError('Nenhum cliente encontrado')
  else
  begin
    JSONPessoas := TJSONArray.Create;

    while not Query.EOF do
    begin

      with Query, PessoaModel do
      begin
        IdPessoa := FieldByName('idpessoa').AsInteger;
        FlNatureza := FieldByName('FlNatureza').AsInteger;
        DsDocumento := FieldByName('dsdocumento').AsString;
        NmPrimeiro := FieldByName('NmPrimeiro').AsString;
        NmSegundo := FieldByName('NmSegundo').AsString;
        DtRegisto := FieldByName('dtregistro').AsDateTime;
      end;
      JSONPessoas.addElement(TJSONObject.ParseJSONValue(PessoaModel.ToJson));
      Query.Next;
    end;

    Result := JSONPessoas;

  end;
end;

procedure TPessoaController.GravaEndereco(iIdPessoa: Integer; sCep: String);
var
  Query: TFDQuery;
  iIdEndereco: Integer;
begin
  try
    try
      Query := PrepareQuery('INSERT INTO ENDERECO( IDENDERECO, IDPESSOA, DSCEP)'
        + 'VALUES (:pIDENDERECO, :pIDPESSOA, :pDSCEP)');
      Query.Connection.StartTransaction;

      iIdEndereco := NextId('Endereco', 'IdEndereco');

      Query.ParamByName('pIDENDERECO').AsInteger := iIdEndereco;
      Query.ParamByName('pIDPESSOA').AsInteger := iIdPessoa;
      Query.ParamByName('pDSCEP').AsString := sCep;
      Query.ExecSQL;
      Query.Connection.Commit;

      GravaEnterecoIntegracao(iIdEndereco);
    except
      Query.Connection.Rollback;
    end;
  finally
    Query.Free;
  end;
end;

procedure TPessoaController.GravaEnterecoIntegracao(iIdEndereco: Integer);
var
  Query: TFDQuery;
begin
  try
    try
      Query := PrepareQuery
        ('INSERT INTO ENDERECO_INTEGRACAO(IDENDERECO) VALUES (:pIDENDERECO)');
      Query.Connection.StartTransaction;
      Query.ParamByName('pIDENDERECO').AsInteger := iIdEndereco;
      Query.ExecSQL;
      Query.Connection.Commit;

    except
      Query.Connection.Rollback;
    end;
  finally
    Query.Free;
  end;
end;

procedure TPessoaController.SetEnderecoModel(const Value: TEnderecoModel);
begin
  FEnderecoModel := Value;
end;

procedure TPessoaController.SetPessoaModel(const Value: TPessoaModel);
begin
  FPessoaModel := Value;
end;

end.
