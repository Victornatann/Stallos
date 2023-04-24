unit uPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, uPessoaModel,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.DBActns, System.Actions,
  Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Buttons, Vcl.Mask, Vcl.Grids, Vcl.DBGrids,
  uCustomApi, uDmClient, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFrmPessoa = class(TForm)
    PageControl1: TPageControl;
    tbsConsulta: TTabSheet;
    GridPessoas: TDBGrid;
    tbsCadastro: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditId: TEdit;
    EditDoc: TEdit;
    EditPrimeiro: TEdit;
    EditSegundo: TEdit;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    CBNatureza: TComboBox;
    Panel1: TPanel;
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    ImageList1: TImageList;
    ImageList16x16: TImageList;
    Panel3: TPanel;
    SpeedButton3: TSpeedButton;
    DsrPessoa: TDataSource;
    Label9: TLabel;
    EditCep: TEdit;
    DsrEndereco: TDataSource;
    procedure btnExcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
  private
    FPessoaModel: TPessoaModel;

    { Private declarations }
  public
    { Public declarations }
    property PessoaModel: TPessoaModel read FPessoaModel;

  end;

var
  FrmPessoa: TFrmPessoa;

implementation

{$R *.dfm}

procedure TFrmPessoa.btnEditarClick(Sender: TObject);
var
  DataSet: TFDMemTable;
begin
  DataSet := (GridPessoas.DataSource.DataSet as TFDMemTable);
  EditId.Text := IntToStr(DataSet.FieldByName('idpessoa').AsInteger);
  // CBNatureza.ItemIndex :=   DataSet.FieldByName('flnatureza').AsInteger;
  EditPrimeiro.Text := DataSet.FieldByName('nmprimeiro').AsString;
  EditSegundo.Text := DataSet.FieldByName('nmsegundo').AsString;
  EditDoc.Text := DataSet.FieldByName('dsdocumento').AsString;

  DMClient.ConsultarEndereco(DataSet.FieldByName('idpessoa').AsInteger);

  PageControl1.ActivePageIndex := 1;
end;

procedure TFrmPessoa.btnExcluirClick(Sender: TObject);
begin
  DMClient.DeletarPessoa(GridPessoas.DataSource.DataSet.FieldByName('idpessoa')
    .AsInteger);
end;

procedure TFrmPessoa.FormCreate(Sender: TObject);
begin
  FPessoaModel := TPessoaModel.Create;
end;

procedure TFrmPessoa.SpeedButton3Click(Sender: TObject);
begin
  with PessoaModel do
  begin
    if StrToInt(EditId.Text) > 0 then
      IdPessoa := StrToInt(EditId.Text)
    else
      IdPessoa := 0;
    FlNatureza := CBNatureza.ItemIndex;
    DsDocumento := EditDoc.Text;
    NmPrimeiro := EditPrimeiro.Text;
    NmSegundo := EditSegundo.Text;
    DsCep := EditCep.Text;
    DtRegisto := Now;
  end;

  DMClient.CadastrarPessoa(PessoaModel);
end;

end.
