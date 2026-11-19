unit UnitFrmCategorias;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, cxClasses,
  dxBar, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  dxDateRanges, dxScrollbarAnnotations, Data.DB, cxDBData, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, System.ImageList, Vcl.ImgList, cxImageList, REST.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, cxCheckBox, cxButtonEdit, System.Threading,  RESTRequest4D;

type
  TfrmCategorias = class(TForm)
    BarraCategorias: TdxBarManager;
    acoesMenuCategorias: TActionList;
    img24x24: TcxImageList;
    acNovaCategoria: TAction;
    BarraCategoriasBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    cxGridCategoriasDBTableViewCategorias: TcxGridDBTableView;
    cxGridCategoriasLevel1: TcxGridLevel;
    cxGridCategorias: TcxGrid;
    acCarregar: TAction;
    dxBarLargeButton3: TdxBarLargeButton;
    RESTClientCategorias: TRESTClient;
    RESTRequestCategorias: TRESTRequest;
    RESTResponseCategorias: TRESTResponse;
    RESTResponseDataSetAdapterCategorias: TRESTResponseDataSetAdapter;
    TabCategorias: TFDMemTable;
    DataSourceCategorias: TDataSource;
    cxGridCategoriasDBTableViewCategoriascategoriaID: TcxGridDBColumn;
    cxGridCategoriasDBTableViewCategoriasnome: TcxGridDBColumn;
    cxGridCategoriasDBTableViewCategoriasdescricao: TcxGridDBColumn;
    cxGridCategoriasDBTableViewCategoriasativo: TcxGridDBColumn;
    cxGridCategoriasDBTableViewCategoriasprodutos: TcxGridDBColumn;
    cxGridCategoriasDBTableViewCategoriasColumn1: TcxGridDBColumn;
    acoesGridCategoria: TActionList;
    acEditar: TAction;
    acExcluir: TAction;
    procedure acCarregarExecute(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
    procedure acNovaCategoriaExecute(Sender: TObject);
    procedure acEditarExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }


  end;

var
  frmCategorias: TfrmCategorias;

implementation

{$R *.dfm}

uses UnitMain, UnitGlobal, UnitFrmCadastrarCategoria;

procedure TfrmCategorias.acCarregarExecute(Sender: TObject);
begin
RESTRequestCategorias.Execute;
end;

procedure TfrmCategorias.acEditarExecute(Sender: TObject);
begin
  if TabCategorias.IsEmpty then
  begin
    ShowMessage('Selecione uma categoria para editar.');
    Exit;
  end;

  frmCadastrarCategoria.Tag := 1;
  frmCadastrarCategoria.IdCategoria := TabCategorias.FieldByName('categoriaID').AsInteger;
  frmCadastrarCategoria.edtNome.Text := TabCategorias.FieldByName('nome').AsString;
  frmCadastrarCategoria.mmDescricao.Text := TabCategorias.FieldByName('descricao').AsString;
  frmCadastrarCategoria.chkAtivo.Checked :=
    TabCategorias.FieldByName('ativo').AsString = 'S';

  frmCadastrarCategoria.ShowModal;
  acCarregar.Execute;
end;

procedure TfrmCategorias.acExcluirExecute(Sender: TObject);
var
  LResponse: IResponse;
  id: string;
begin
  if TabCategorias.IsEmpty then
  begin
    ShowMessage('Selecione uma categoria para excluir.');
    Exit;
  end;

  id:= TabCategorias.FieldByName('categoriaID').AsString;

  LResponse := TRequest.New
    .BaseURL(URL_API)
    .Resource('Categorias/'+id)
    .Accept('application/json')
    .Delete;
  if LResponse.StatusCode in [200, 202, 204] then
  begin
  acCarregar.Execute;
  end

  else
    ShowMessage('Falha: ' + IntToStr(LResponse.StatusCode));
end;

procedure TfrmCategorias.acNovaCategoriaExecute(Sender: TObject);
begin
  frmCadastrarCategoria.Tag := 0;
  frmCadastrarCategoria.IdCategoria := 0;
  frmCadastrarCategoria.edtNome.Clear;
  frmCadastrarCategoria.mmDescricao.Clear;
  frmCadastrarCategoria.chkAtivo.Checked := True;

  frmCadastrarCategoria.ShowModal;
  acCarregar.Execute;
end;

end.
