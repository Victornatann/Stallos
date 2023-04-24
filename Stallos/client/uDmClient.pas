unit uDmClient;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  System.Generics.Collections,
  Data.Bind.Components, Data.Bind.ObjectScope, URetorno, uPessoaModel,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uEnderecoModel;

type
  TDMClient = class(TDataModule)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    DSPessoas: TFDMemTable;
    DSPessoasidpessoa: TIntegerField;
    DSPessoasdsdocumento: TStringField;
    DSPessoasnmprimeiro: TStringField;
    DSPessoasnmsegundo: TStringField;
    DSEndereco: TFDMemTable;
    DSEnderecodsuf: TStringField;
    DSEnderecodscep: TStringField;
    DSEndereconmcidade: TStringField;
    DSEndereconmbairro: TStringField;
    DSEndereconmlogradouro: TStringField;
    DSEnderecodscomplemento: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    FRetorno: TRetorno;
    FPessoas: TPessoas;
    FEndereco: TEnderecos;
    procedure SetPessoas(const Value: TPessoas);
    procedure SetEndereco(const Value: TEnderecos);

    { Private declarations }
  public
    { Public declarations }

    property Retorno: TRetorno read FRetorno;
    property Pessoas: TPessoas read FPessoas write SetPessoas;
    property Endereco : TEnderecos read FEndereco write SetEndereco;

    function ConsultarPessoas: Integer;
    procedure DeletarPessoa(ID_PESSOA: Integer);
    procedure CadastrarPessoa(Pessoa: TPessoaModel);
    procedure ConsultarEndereco(ID_PESSOA: Integer);

  end;

var
  DMClient: TDMClient;

const
  BaseUrl = 'http://localhost:8080/datasnap/rest/TSMService';

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uPessoa, Vcl.Dialogs;
{$R *.dfm}

procedure TDMClient.CadastrarPessoa(Pessoa: TPessoaModel);
var
  RetOK: Boolean;
  MensagemRetorno: String;
begin
  RESTRequest.Params.Clear;
  RESTClient.BaseUrl := BaseUrl + '/Pessoa';
  if not Pessoa.IdPessoa > 0 then
    RESTRequest.Method := rmPOST
  else
  begin
    RESTRequest.Method := rmPUT;
    RESTClient.BaseUrl := BaseUrl + '/' + IntToStr(Pessoa.IdPessoa);
  end;

  try
    RESTRequest.AddBody(Pessoa.toJSON, ctAPPLICATION_JSON);
    RESTRequest.Execute;

    FRetorno.TratarRetorno(RESTResponse);
    RetOK := FRetorno.RetornoOK;

    if FRetorno.RetornoOK then
      MensagemRetorno := RESTResponse.StatusText
    else
      MensagemRetorno := RESTResponse.Content;
  except
    on E: Exception do
    begin
      RetOK := False;
      MensagemRetorno := E.Message;
    end;
  end;

  ShowMessage(MensagemRetorno);
end;

procedure TDMClient.ConsultarEndereco(ID_PESSOA: Integer);
var
  RetOK: Boolean;
  MensagemRetorno: String;
  i: Integer;
begin
  RESTRequest.Method := rmGET;

  RESTClient.BaseUrl := BaseUrl + '/Endereco/' + IntToStr(ID_PESSOA);

  try
    RESTRequest.Execute;

    FRetorno.TratarRetorno(RESTResponse);
    RetOK := FRetorno.RetornoOK;

    if FRetorno.RetornoOK then
      MensagemRetorno := RESTResponse.StatusText
    else
      MensagemRetorno := RESTResponse.Content;
  except
    on E: Exception do
    begin
      RetOK := False;
      MensagemRetorno := E.Message;
    end;
  end;

  if RetOK then
  begin
    // Pega o JSON recebido e transforma em objeto

    Endereco.FromJSON(Trim(RESTResponse.Content));
    DSEndereco.Open;

    for i := 0 to Endereco.EnderecoList.Count - 1 do
    begin
      DSEndereco.Append;
      DSEnderecodscep.AsString  := Endereco.EnderecoList[i].DsCep;
      DSEnderecodsuf.AsString := Endereco.EnderecoList[i].DsUf;
      DSEndereconmcidade.AsString := Endereco.EnderecoList[i].NmCidade;
      DSEndereconmbairro.AsString := Endereco.EnderecoList[i].NmBairro;
      DSEndereco.Post;
    end;

  end;
end;

function TDMClient.ConsultarPessoas: Integer;
var
  RetOK: Boolean;
  MensagemRetorno: String;
  i: Integer;
begin
  RESTRequest.Method := rmGET;

  RESTClient.BaseUrl := BaseUrl + '/Pessoa';

  try
    RESTRequest.Execute;

    FRetorno.TratarRetorno(RESTResponse);
    RetOK := FRetorno.RetornoOK;

    if FRetorno.RetornoOK then
      MensagemRetorno := RESTResponse.StatusText
    else
      MensagemRetorno := RESTResponse.Content;
  except
    on E: Exception do
    begin
      RetOK := False;
      MensagemRetorno := E.Message;
    end;
  end;

  if RetOK then
  begin
    // Pega o JSON recebido e transforma em objeto
    Pessoas.FromJSON(Trim(RESTResponse.Content));
    DSPessoas.Open;

    for i := 0 to Pessoas.PessoaList.Count - 1 do
    begin
      DSPessoas.Append;
      DSPessoasidpessoa.AsInteger := Pessoas.PessoaList[i].IdPessoa;
      DSPessoasdsdocumento.AsString := Pessoas.PessoaList[i].DsDocumento;
      DSPessoasnmprimeiro.AsString := Pessoas.PessoaList[i].NmPrimeiro;
      DSPessoasnmsegundo.AsString := Pessoas.PessoaList[i].NmSegundo;
      DSPessoas.Post;
    end;

  end;

end;

procedure TDMClient.DataModuleCreate(Sender: TObject);
begin

  with RESTClient do
  begin
    Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
    AcceptCharset := 'utf-8, *;q=0.8';
    ContentType := 'application/json';

    RaiseExceptionOn500 := False;
  end;

  with RESTResponse do
  begin
    ContentType := 'application/json';
  end;

  with RESTRequest do
  begin
    Client := RESTClient;
    Response := RESTResponse;
    SynchronizedEvents := False;
  end;

  FRetorno := TRetorno.getInstancia;
  Pessoas := TPessoas.create;
  Endereco := TEnderecos.create;
  ConsultarPessoas();
end;

procedure TDMClient.DeletarPessoa(ID_PESSOA: Integer);
var
  RetOK: Boolean;
  MensagemRetorno: String;
begin
  RESTRequest.Method := rmDELETE;
  RESTClient.BaseUrl := BaseUrl + '/Pessoa' + '/' + IntToStr(ID_PESSOA);

  try
    RESTRequest.Execute;

    FRetorno.TratarRetorno(RESTResponse);
    RetOK := FRetorno.RetornoOK;

    if FRetorno.RetornoOK then
      MensagemRetorno := RESTResponse.StatusText
    else
      MensagemRetorno := RESTResponse.Content;
  except
    on E: Exception do
    begin
      RetOK := False;
      MensagemRetorno := E.Message;
    end;
  end;

  ShowMessage(MensagemRetorno);
end;

procedure TDMClient.SetEndereco(const Value: TEnderecos);
begin
  FEndereco := Value;
end;

procedure TDMClient.SetPessoas(const Value: TPessoas);
begin
  FPessoas := Value;
end;

end.
