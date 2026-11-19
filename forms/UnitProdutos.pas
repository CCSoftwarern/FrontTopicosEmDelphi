unit UnitProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  Data.DB, cxDBData, cxCheckBox, cxButtonEdit, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.ImageList, Vcl.ImgList, cxImageList,
  System.Actions, Vcl.ActnList, dxBar, cxClasses, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxDBLookupComboBox,  RESTRequest4D;

type
  TfrmProdutos = class(TForm)
    cxGridClientes: TcxGrid;
    cxGridClientesDBTableViewClientes: TcxGridDBTableView;
    cxGridClientesLevel1: TcxGridLevel;
    BarraProdutos: TdxBarManager;
    BarraCategoriasBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    acoesMenuProdutos: TActionList;
    acNovoProduto: TAction;
    acCarregar: TAction;
    img24x24: TcxImageList;
    RESTClientProdutos: TRESTClient;
    RESTRequestPrdutos: TRESTRequest;
    RESTResponseProdutos: TRESTResponse;
    RESTResponseDataSetAdapterProdutos: TRESTResponseDataSetAdapter;
    TabProdutos: TFDMemTable;
    DataSourceProdutos: TDataSource;
    acoesGridProdutos: TActionList;
    acEditar: TAction;
    acExcluir: TAction;
    cxGridClientesDBTableViewClientesprodutoID: TcxGridDBColumn;
    cxGridClientesDBTableViewClientescategoriaID: TcxGridDBColumn;
    cxGridClientesDBTableViewClientesnome: TcxGridDBColumn;
    cxGridClientesDBTableViewClientesdescricao: TcxGridDBColumn;
    cxGridClientesDBTableViewClientespreco: TcxGridDBColumn;
    cxGridClientesDBTableViewClientesestoque: TcxGridDBColumn;
    cxGridClientesDBTableViewClientesdataCadastro: TcxGridDBColumn;
    cxGridClientesDBTableViewClientesativo: TcxGridDBColumn;
    RESTRequestCategorias: TRESTRequest;
    RESTClientCategorias: TRESTClient;
    RESTResponseCategorias: TRESTResponse;
    RESTResponseDataSetAdapterCategorias: TRESTResponseDataSetAdapter;
    TabCategorias: TFDMemTable;
    DataSourceCategorias: TDataSource;
    cxGridClientesDBTableViewClientesColumn1: TcxGridDBColumn;
    procedure acCarregarExecute(Sender: TObject);
    procedure acEditarExecute(Sender: TObject);
    procedure acNovoProdutoExecute(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProdutos: TfrmProdutos;

implementation

{$R *.dfm}

uses UnitMain, UnitCadastrarProduto, UnitGlobal;

procedure TfrmProdutos.acCarregarExecute(Sender: TObject);
begin
try
  RESTRequestCategorias.execute;
finally
  RESTRequestPrdutos.Execute;
end;

end;

procedure TfrmProdutos.acEditarExecute(Sender: TObject);
begin
begin
  if TabProdutos.IsEmpty then
  begin
    ShowMessage('Selecione um produto para editar.');
    Exit;
  end;

  with frmCadastrarProduto do begin
    Tag:= 1;
    IdProduto:= TabProdutos.FieldByName('produtoID').AsInteger;
    comboCategoria.EditValue:= TabProdutos.FieldByName('categoriaid').asinteger;
    edtNome.Text:= TabProdutos.FieldByName('nome').AsString;
    mmDescricao.Text:= TabProdutos.FieldByName('descricao').AsString;
    edtValor.Value:=  TabProdutos.FieldByName('preco').Value;
    spnEstoque.Value:=  TabProdutos.FieldByName('estoque').Value;
    DataCadastro:= TabProdutos.FieldByName('dataCadastro').AsString;
    chkAtivo.Checked := TabProdutos.FieldByName('ativo').AsString = 'S';
    ShowModal;
  end;

  acCarregar.Execute;
end;
end;

procedure TfrmProdutos.acExcluirExecute(Sender: TObject);
var
  LResponse: IResponse;
  id: string;
begin
  if TabProdutos.IsEmpty then
  begin
    ShowMessage('Selecione uma produto para excluir.');
    Exit;
  end;

  id:= TabProdutos.FieldByName('produtoID').AsString;

  LResponse := TRequest.New
    .BaseURL(URL_API)
    .Resource('produtos/'+id)
    .Accept('application/json')
    .Delete;
  if LResponse.StatusCode in [200, 202, 204] then
  begin
  acCarregar.Execute;
  end

  else
    ShowMessage('Falha: ' + IntToStr(LResponse.StatusCode));

end;

procedure TfrmProdutos.acNovoProdutoExecute(Sender: TObject);
begin
  with frmCadastrarProduto do begin
  Tag:= 0;
  comboCategoria.EditValue:= -1;
  edtNome.Text:= '';
  mmDescricao.Text:= '';
  edtValor.Value:=  0;
  spnEstoque.Value:=  1;
  chkAtivo.Checked:=True;
  ShowModal;

  end;
   acCarregar.Execute;
end;

end.
