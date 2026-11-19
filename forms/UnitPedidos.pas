unit UnitPedidos;

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
  cxGrid, System.UITypes;

type
  TfrmPedido = class(TForm)
    cxGridPedidos: TcxGrid;
    cxGridPedidosDBTableViewPedido: TcxGridDBTableView;
    cxGridPedidosDBTableViewPedidoColumn1: TcxGridDBColumn;
    cxGridPedidosLevel1: TcxGridLevel;
    BarraPedido: TdxBarManager;
    BarraCategoriasBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    acoesMenuPedido: TActionList;
    acNovoPedido: TAction;
    acCarregar: TAction;
    img24x24: TcxImageList;
    RESTClientPedido: TRESTClient;
    RESTRequestPedidos: TRESTRequest;
    RESTResponsePedido: TRESTResponse;
    RESTResponseDataSetAdapterPedido: TRESTResponseDataSetAdapter;
    TabPedido: TFDMemTable;
    DataSourcePedido: TDataSource;
    acoesGridPedido: TActionList;
    acEditar: TAction;
    acExcluir: TAction;
    cxGridPedidosDBTableViewPedidopedidoID: TcxGridDBColumn;
    cxGridPedidosDBTableViewPedidoclienteID: TcxGridDBColumn;
    cxGridPedidosDBTableViewPedidoclienteNome: TcxGridDBColumn;
    cxGridPedidosDBTableViewPedidodataPedido: TcxGridDBColumn;
    cxGridPedidosDBTableViewPedidosituacao: TcxGridDBColumn;
    cxGridPedidosDBTableViewPedidovalorTotal: TcxGridDBColumn;
    cxGridPedidosDBTableViewPedidoitens: TcxGridDBColumn;
    procedure acCarregarExecute(Sender: TObject);
    procedure acNovoPedidoExecute(Sender: TObject);
    procedure acEditarExecute(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
  private
    function PedidoSelecionado: Integer;
    procedure AbrirCadastro(const APedidoID: Integer);
    procedure AjustarColunas;
    procedure DataPedidoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ValorTotalGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  public
    { Public declarations }
  end;

var
  frmPedido: TfrmPedido;

implementation

{$R *.dfm}

uses UnitMain, UnitCadastrarPedido, UnitGlobal, RESTRequest4D, System.DateUtils;

function TfrmPedido.PedidoSelecionado: Integer;
begin
  if TabPedido.IsEmpty then
    Result := 0
  else
    Result := TabPedido.FieldByName('pedidoID').AsInteger;
end;

procedure TfrmPedido.acCarregarExecute(Sender: TObject);
begin
  try
    RESTRequestPedidos.Execute;
    AjustarColunas;
  except
    on E: Exception do
      ShowMessage('N'#227'o foi poss'#237'vel carregar os pedidos.' +
        sLineBreak + E.Message);
  end;
end;

procedure TfrmPedido.AjustarColunas;
var
  LField: TField;
begin
  // Os campos criados pelo RESTResponseDataSetAdapter sao texto puro.
  // Aqui so mudamos o que aparece na tela (data e valor formatados).
  LField := TabPedido.FindField('dataPedido');
  if LField <> nil then
    LField.OnGetText := DataPedidoGetText;

  LField := TabPedido.FindField('valorTotal');
  if LField <> nil then
    LField.OnGetText := ValorTotalGetText;
end;

procedure TfrmPedido.DataPedidoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
var
  LData: TDateTime;
begin
  if not DisplayText then
    Exit;
  if Trim(Sender.AsString) = '' then
  begin
    Text := '';
    Exit;
  end;
  if TryISO8601ToDate(Sender.AsString, LData) then
    Text := FormatDateTime('dd/mm/yyyy hh:nn', LData);
end;

procedure TfrmPedido.ValorTotalGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
var
  LTexto: string;
  LFS: TFormatSettings;
begin
  if not DisplayText then
    Exit;

  LTexto := Trim(Sender.AsString);
  if LTexto = '' then
  begin
    Text := '';
    Exit;
  end;

  LFS := TFormatSettings.Create;
  LFS.DecimalSeparator := '.';
  LFS.ThousandSeparator := #0;

  Text := CurrToStr(StrToFloatDef(LTexto, 0, LFS));
end;

procedure TfrmPedido.acNovoPedidoExecute(Sender: TObject);
begin
  AbrirCadastro(0);
end;

procedure TfrmPedido.acEditarExecute(Sender: TObject);
begin
  if PedidoSelecionado <= 0 then
  begin
    ShowMessage('Selecione um pedido para editar.');
    Exit;
  end;

  AbrirCadastro(PedidoSelecionado);
end;

procedure TfrmPedido.acExcluirExecute(Sender: TObject);
var
  LId: Integer;
  LResponse: IResponse;
begin
  LId := PedidoSelecionado;
  if LId <= 0 then
  begin
    ShowMessage('Selecione um pedido para excluir.');
    Exit;
  end;

  if MessageDlg(Format('Excluir o pedido #%d e todos os seus itens?', [LId]),
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    LResponse := TRequest.New
      .BaseURL(URL_API)
      .Resource('pedidos/' + IntToStr(LId))
      .Accept('application/json')
      .Delete;
  except
    on E: Exception do
    begin
      ShowMessage('Falha ao excluir o pedido: ' + E.Message);
      Exit;
    end;
  end;

  if LResponse.StatusCode in [200, 202, 204] then
    acCarregar.Execute
  else
    ShowMessage('Falha ao excluir o pedido (' + IntToStr(LResponse.StatusCode) + ').' +
      sLineBreak + LResponse.Content);
end;

procedure TfrmPedido.AbrirCadastro(const APedidoID: Integer);
begin
  with frmCadastrarPedido do
  begin
    PedidoID := APedidoID;
    if ShowModal = mrOk then
      acCarregar.Execute;
  end;
end;

end.
