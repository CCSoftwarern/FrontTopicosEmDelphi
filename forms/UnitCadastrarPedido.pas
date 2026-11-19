unit UnitCadastrarPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, Data.DB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations, cxDBData,
  cxContainer, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, cxSpinEdit, cxCurrencyEdit, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Client, REST.Types,
  REST.Response.Adapter, System.JSON, RESTRequest4D, System.Generics.Collections;

const
  WM_TOTAL_PEDIDO = WM_USER + 210;

type
  TfrmCadastrarPedido = class(TForm)
    pnlTopo: TPanel;
    lblCliente: TLabel;
    cbCliente: TcxLookupComboBox;
    lblSituacao: TLabel;
    cbSituacao: TcxComboBox;
    pnlItens: TPanel;
    lblProduto: TLabel;
    cbProduto: TcxLookupComboBox;
    lblQuantidade: TLabel;
    spnQuantidade: TSpinEdit;
    btnAdicionarItem: TButton;
    btnRemoverItem: TButton;
    cxGridItens: TcxGrid;
    cxGridItensDBTableViewItem: TcxGridDBTableView;
    cxGridItensDBTableViewItemprodutoNome: TcxGridDBColumn;
    cxGridItensDBTableViewItemquantidade: TcxGridDBColumn;
    cxGridItensDBTableViewItemprecoUnitario: TcxGridDBColumn;
    cxGridItensDBTableViewItemsubTotal: TcxGridDBColumn;
    cxGridItensLevel1: TcxGridLevel;
    pnlRodape: TPanel;
    lblTotal: TLabel;
    btnGravar: TButton;
    btnCancelar: TButton;
    TabItens: TFDMemTable;
    DataSourceItens: TDataSource;
    RESTClientClientes: TRESTClient;
    RESTRequestClientes: TRESTRequest;
    RESTResponseClientes: TRESTResponse;
    RESTResponseDataSetAdapterClientes: TRESTResponseDataSetAdapter;
    TabClientes: TFDMemTable;
    DataSourceClientes: TDataSource;
    RESTClientProdutos: TRESTClient;
    RESTRequestProdutos: TRESTRequest;
    RESTResponseProdutos: TRESTResponse;
    RESTResponseDataSetAdapterProdutos: TRESTResponseDataSetAdapter;
    TabProdutos: TFDMemTable;
    DataSourceProdutos: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnRemoverItemClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure TabItensBeforePost(DataSet: TDataSet);
    procedure TabItensAfterPost(DataSet: TDataSet);
    procedure TabItensAfterDelete(DataSet: TDataSet);
  private
    FPedidoID: Integer;
    FItensOriginais: TStringList;
    FRecalculando: Boolean;
    procedure WMTotalPedido(var Msg: TMessage); message WM_TOTAL_PEDIDO;
    procedure AgendarTotal;
    procedure CarregarCombos;
    procedure CarregarPedido;
    procedure RecalcularTotal;
    procedure InserirItem(AItemPedidoID, AProdutoID, AQuantidade: Integer;
      APrecoUnitario: Currency; const AProdutoNome: string; AQtdOriginal: Integer);
    function ItemNaLista(AItemPedidoID: Integer): Boolean;
    function ClienteSelecionado: Integer;
    function ProdutoSelecionado: Integer;
    function SituacaoSelecionada: string;
    function GravarNovo: Boolean;
    function GravarEdicao: Boolean;
    function Enviar(const ARecurso: string; AJson: TJSONObject;
      APost: Boolean): IResponse;
    function Excluir(const ARecurso: string): IResponse;
    procedure Falha(const AAcao: string; AResponse: IResponse);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property PedidoID: Integer read FPedidoID write FPedidoID;
  end;

var
  frmCadastrarPedido: TfrmCadastrarPedido;

implementation

{$R *.dfm}

uses UnitGlobal;

{ funcoes auxiliares }

function StrToFloatAPI(const ATexto: string): Currency;
var
  LTexto: string;
  LFS: TFormatSettings;
begin
  LTexto := Trim(ATexto);
  if LTexto = '' then
    Exit(0);

  // A API devolve os numeros com ponto decimal (ex.: 100.00)
  if (Pos('.', LTexto) > 0) and (Pos(',', LTexto) > 0) then
  begin
    LTexto := StringReplace(LTexto, '.', '', [rfReplaceAll]);
    LTexto := StringReplace(LTexto, ',', '.', [rfReplaceAll]);
  end
  else if Pos(',', LTexto) > 0 then
    LTexto := StringReplace(LTexto, ',', '.', [rfReplaceAll]);

  LFS := TFormatSettings.Create;
  LFS.DecimalSeparator := '.';
  LFS.ThousandSeparator := #0;

  Result := StrToFloatDef(LTexto, 0, LFS);
end;

function MensagemResposta(AResponse: IResponse): string;
var
  LJSON: TJSONValue;
begin
  Result := Trim(AResponse.Content);
  if Result = '' then
    Exit;

  LJSON := TJSONObject.ParseJSONValue(Result);
  try
    if (LJSON <> nil) and (LJSON is TJSONObject) then
      if TJSONObject(LJSON).GetValue('message') <> nil then
        Result := TJSONObject(LJSON).GetValue('message').Value;
  finally
    LJSON.Free;
  end;
end;

function IdDoItem(const AConteudo: string): Integer;
var
  LJSON: TJSONValue;
begin
  Result := 0;
  LJSON := TJSONObject.ParseJSONValue(AConteudo);
  try
    if (LJSON <> nil) and (LJSON is TJSONObject) then
      if TJSONObject(LJSON).GetValue('itemPedidoID') is TJSONNumber then
        Result := (TJSONObject(LJSON).GetValue('itemPedidoID') as TJSONNumber).AsInt;
  finally
    LJSON.Free;
  end;
end;

{ TfrmCadastrarPedido }

constructor TfrmCadastrarPedido.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItensOriginais := TStringList.Create;
  // A tabela de itens e local (nao vem da API), entao precisa ser aberta
  // depois que os FieldDefs do DFM foram aplicados.
  if not TabItens.Active then
    TabItens.Open;
end;

destructor TfrmCadastrarPedido.Destroy;
begin
  FItensOriginais.Free;
  inherited Destroy;
end;

procedure TfrmCadastrarPedido.FormShow(Sender: TObject);
begin
  FItensOriginais.Clear;
  FRecalculando := False;

  TabItens.DisableControls;
  try
    TabItens.EmptyDataSet;
  finally
    TabItens.EnableControls;
  end;

  cbCliente.EditValue := Null;
  cbProduto.EditValue := Null;
  cbSituacao.ItemIndex := 0;
  spnQuantidade.Value := 1;

  CarregarCombos;

  if FPedidoID > 0 then
  begin
    Caption := 'Editar pedido #' + IntToStr(FPedidoID);
    CarregarPedido;
  end
  else
    Caption := 'Novo pedido';

  RecalcularTotal;

  if (FPedidoID <= 0) and (not TabClientes.IsEmpty) and cbCliente.CanFocus then
    cbCliente.SetFocus;
end;

procedure TfrmCadastrarPedido.CarregarCombos;
begin
  try
    RESTRequestClientes.Execute;
  except
    on E: Exception do
      ShowMessage('N'#227'o foi poss'#237'vel carregar os clientes.' +
        sLineBreak + E.Message);
  end;

  try
    RESTRequestProdutos.Execute;
  except
    on E: Exception do
      ShowMessage('N'#227'o foi poss'#237'vel carregar os produtos.' +
        sLineBreak + E.Message);
  end;
end;

procedure TfrmCadastrarPedido.CarregarPedido;
var
  LResponse: IResponse;
  LJSON: TJSONValue;
  LObj, LItem: TJSONObject;
  LItens: TJSONArray;
  I: Integer;
  LItemID, LProdutoID, LQuantidade: Integer;
  LNome: string;
  LPreco: Currency;
begin
  try
    LResponse := TRequest.New
      .BaseURL(URL_API)
      .Resource('pedidos/' + IntToStr(FPedidoID))
      .Accept('application/json')
      .Get;
  except
    on E: Exception do
    begin
      ShowMessage('N'#227'o foi poss'#237'vel carregar o pedido.' +
        sLineBreak + E.Message);
      Exit;
    end;
  end;

  if LResponse.StatusCode <> 200 then
  begin
    Falha('carregar o pedido', LResponse);
    Exit;
  end;

  LJSON := TJSONObject.ParseJSONValue(LResponse.Content);
  if (LJSON = nil) or (not (LJSON is TJSONObject)) then
  begin
    LJSON.Free;
    ShowMessage('Resposta inv'#225'lida do servidor.');
    Exit;
  end;

  try
    LObj := TJSONObject(LJSON);

    cbCliente.EditValue := IntToStr(LObj.GetValue<Integer>('clienteID'));

    I := cbSituacao.Properties.Items.IndexOf(LObj.GetValue<string>('situacao'));
    if I >= 0 then
      cbSituacao.ItemIndex := I
    else
      cbSituacao.ItemIndex := 0;

    LItens := LObj.GetValue<TJSONArray>('itens');
    if LItens <> nil then
      for I := 0 to LItens.Count - 1 do
      begin
        LItem := LItens.Items[I] as TJSONObject;

        LItemID := LItem.GetValue<Integer>('itemPedidoID');
        LProdutoID := LItem.GetValue<Integer>('produtoID');
        LQuantidade := LItem.GetValue<Integer>('quantidade');
        LNome := LItem.GetValue<string>('produtoNome');
        LPreco := 0;
        if LItem.GetValue('precoUnitario') is TJSONNumber then
          LPreco := (LItem.GetValue('precoUnitario') as TJSONNumber).AsDouble;

        InserirItem(LItemID, LProdutoID, LQuantidade, LPreco, LNome, LQuantidade);

        if LItemID > 0 then
          FItensOriginais.Add(IntToStr(LItemID));
      end;
  finally
    LJSON.Free;
  end;
end;

procedure TfrmCadastrarPedido.InserirItem(AItemPedidoID, AProdutoID,
  AQuantidade: Integer; APrecoUnitario: Currency; const AProdutoNome: string;
  AQtdOriginal: Integer);
begin
  TabItens.Append;
  TabItens.FieldByName('itemPedidoID').AsInteger := AItemPedidoID;
  TabItens.FieldByName('produtoID').AsInteger := AProdutoID;
  TabItens.FieldByName('produtoNome').AsString := AProdutoNome;
  TabItens.FieldByName('quantidade').AsInteger := AQuantidade;
  TabItens.FieldByName('precoUnitario').AsCurrency := APrecoUnitario;
  TabItens.FieldByName('subTotal').AsCurrency := APrecoUnitario * AQuantidade;
  TabItens.FieldByName('qtdOriginal').AsInteger := AQtdOriginal;
  TabItens.Post;
end;

function TfrmCadastrarPedido.ItemNaLista(AItemPedidoID: Integer): Boolean;
var
  LBm: TBookmark;
begin
  Result := False;
  if AItemPedidoID <= 0 then
    Exit;

  LBm := TabItens.Bookmark;
  TabItens.DisableControls;
  try
    TabItens.First;
    while not TabItens.Eof do
    begin
      if TabItens.FieldByName('itemPedidoID').AsInteger = AItemPedidoID then
      begin
        Result := True;
        Break;
      end;
      TabItens.Next;
    end;
    if TabItens.BookmarkValid(LBm) then
      TabItens.Bookmark := LBm;
  finally
    TabItens.EnableControls;
  end;
end;

procedure TfrmCadastrarPedido.RecalcularTotal;
var
  LBm: TBookmark;
  LTotal: Currency;
begin
  if FRecalculando or (not TabItens.Active) then
    Exit;

  // Mensagem agendada pode chegar durante o fechamento do formulario.
  if (csDestroying in ComponentState) or (csLoading in ComponentState) then
    Exit;

  // Navegar no dataset durante uma edicao faria o registro ser postado,
  // entao esperamos o grid concluir a edicao.
  if TabItens.State in [dsEdit, dsInsert] then
    Exit;

  FRecalculando := True;
  try
    LTotal := 0;
    LBm := TabItens.Bookmark;
    TabItens.DisableControls;
    try
      TabItens.First;
      while not TabItens.Eof do
      begin
        LTotal := LTotal + TabItens.FieldByName('subTotal').AsCurrency;
        TabItens.Next;
      end;
      if TabItens.BookmarkValid(LBm) then
        TabItens.Bookmark := LBm;
    finally
      TabItens.EnableControls;
    end;
    lblTotal.Caption := 'Total: ' + CurrToStrF(LTotal, ffNumber, 2);
  finally
    FRecalculando := False;
  end;
end;

function TfrmCadastrarPedido.ClienteSelecionado: Integer;
begin
  Result := StrToIntDef(VarToStr(cbCliente.EditValue), 0);
end;

function TfrmCadastrarPedido.ProdutoSelecionado: Integer;
begin
  Result := StrToIntDef(VarToStr(cbProduto.EditValue), 0);
end;

function TfrmCadastrarPedido.SituacaoSelecionada: string;
begin
  if (cbSituacao.ItemIndex >= 0) and
     (cbSituacao.ItemIndex < cbSituacao.Properties.Items.Count) then
    Result := cbSituacao.Properties.Items[cbSituacao.ItemIndex]
  else
    Result := 'PENDENTE';
end;

procedure TfrmCadastrarPedido.btnAdicionarItemClick(Sender: TObject);
var
  LProdutoID, LQuantidade, LEstoque: Integer;
  LNome: string;
  LPreco: Currency;
begin
  LProdutoID := ProdutoSelecionado;
  if LProdutoID <= 0 then
  begin
    ShowMessage('Selecione um produto.');
    if cbProduto.CanFocus then
      cbProduto.SetFocus;
    Exit;
  end;

  LQuantidade := spnQuantidade.Value;
  if LQuantidade <= 0 then
  begin
    ShowMessage('Informe uma quantidade maior que zero.');
    if spnQuantidade.CanFocus then
      spnQuantidade.SetFocus;
    Exit;
  end;

  LNome := VarToStr(TabProdutos.Lookup('produtoID', IntToStr(LProdutoID), 'nome'));
  LPreco := StrToFloatAPI(VarToStr(TabProdutos.Lookup('produtoID',
    IntToStr(LProdutoID), 'preco')));
  LEstoque := StrToIntDef(VarToStr(TabProdutos.Lookup('produtoID',
    IntToStr(LProdutoID), 'estoque')), 0);

  if LEstoque < LQuantidade then
  begin
    ShowMessage(Format('Estoque insuficiente para "%s". Dispon'#237'vel: %d.',
      [LNome, LEstoque]));
    Exit;
  end;

  TabItens.DisableControls;
  try
    // A API sempre cria uma nova linha para o mesmo produto,
    // entao agrupamos as quantidades aqui.
    if TabItens.Locate('produtoID', LProdutoID, []) then
    begin
      TabItens.Edit;
      TabItens.FieldByName('quantidade').AsInteger :=
        TabItens.FieldByName('quantidade').AsInteger + LQuantidade;
      TabItens.Post;
    end
    else
      InserirItem(0, LProdutoID, LQuantidade, LPreco, LNome, 0);
  finally
    TabItens.EnableControls;
  end;

  RecalcularTotal;

  cbProduto.EditValue := Null;
  spnQuantidade.Value := 1;
  if cbProduto.CanFocus then
    cbProduto.SetFocus;
end;

procedure TfrmCadastrarPedido.btnRemoverItemClick(Sender: TObject);
begin
  if TabItens.IsEmpty then
  begin
    ShowMessage('O pedido n'#227'o possui itens.');
    Exit;
  end;

  TabItens.Delete;
  RecalcularTotal;
end;

procedure TfrmCadastrarPedido.TabItensBeforePost(DataSet: TDataSet);
begin
  if TabItens.State in [dsEdit, dsInsert] then
    TabItens.FieldByName('subTotal').AsCurrency :=
      TabItens.FieldByName('quantidade').AsInteger *
      TabItens.FieldByName('precoUnitario').AsCurrency;
end;

// Navegar no dataset dentro de um evento do proprio dataset (Post/Delete)
// causa reentrancia. Por isso o recalculo do total e agendado para depois
// que a operacao termina.
procedure TfrmCadastrarPedido.AgendarTotal;
begin
  if HandleAllocated then
    PostMessage(Handle, WM_TOTAL_PEDIDO, 0, 0)
  else
    RecalcularTotal;
end;

procedure TfrmCadastrarPedido.WMTotalPedido(var Msg: TMessage);
begin
  RecalcularTotal;
end;

procedure TfrmCadastrarPedido.TabItensAfterPost(DataSet: TDataSet);
begin
  AgendarTotal;
end;

procedure TfrmCadastrarPedido.TabItensAfterDelete(DataSet: TDataSet);
begin
  AgendarTotal;
end;

procedure TfrmCadastrarPedido.btnGravarClick(Sender: TObject);
var
  LOk: Boolean;
begin
  if (ClienteSelecionado <= 0) then
  begin
    ShowMessage('Selecione o cliente do pedido.');
    if cbCliente.CanFocus then
      cbCliente.SetFocus;
    Exit;
  end;

  if TabItens.IsEmpty then
  begin
    ShowMessage('Adicione pelo menos um item ao pedido.');
    if cbProduto.CanFocus then
      cbProduto.SetFocus;
    Exit;
  end;

  // Garante que a quantidade que esta sendo digitada no grid seja aplicada
  try
    cxGridItensDBTableViewItem.DataController.PostEditingData;
  except
    // valor invalido: o grid mantem a edicao aberta
  end;

  if TabItens.State in [dsEdit, dsInsert] then
  begin
    try
      TabItens.Post;
    except
      on E: Exception do
      begin
        ShowMessage('Finalize a edi'#231#227'o dos itens. ' + E.Message);
        Exit;
      end;
    end;
  end;

  btnGravar.Enabled := False;
  try
    if FPedidoID > 0 then
      LOk := GravarEdicao
    else
      LOk := GravarNovo;
  finally
    btnGravar.Enabled := True;
  end;

  if LOk then
    ModalResult := mrOk;
end;

function TfrmCadastrarPedido.Enviar(const ARecurso: string; AJson: TJSONObject;
  APost: Boolean): IResponse;
begin
  if APost then
    Result := TRequest.New
      .BaseURL(URL_API)
      .Resource(ARecurso)
      .Accept('application/json')
      .ContentType('application/json')
      .AddBody(AJson, False)
      .Post
  else
    Result := TRequest.New
      .BaseURL(URL_API)
      .Resource(ARecurso)
      .Accept('application/json')
      .ContentType('application/json')
      .AddBody(AJson, False)
      .Put;
end;

function TfrmCadastrarPedido.Excluir(const ARecurso: string): IResponse;
begin
  Result := TRequest.New
    .BaseURL(URL_API)
    .Resource(ARecurso)
    .Accept('application/json')
    .Delete;
end;

procedure TfrmCadastrarPedido.Falha(const AAcao: string; AResponse: IResponse);
begin
  ShowMessage('Falha ao ' + AAcao + ' (' + IntToStr(AResponse.StatusCode) + ').' +
    sLineBreak + MensagemResposta(AResponse));
end;

function TfrmCadastrarPedido.GravarNovo: Boolean;
var
  LJson, LItem: TJSONObject;
  LItens: TJSONArray;
  LResponse: IResponse;
begin
  Result := False;

  LJson := TJSONObject.Create;
  try
    LJson.AddPair('clienteID', ClienteSelecionado);
    LJson.AddPair('situacao', SituacaoSelecionada);

    LItens := TJSONArray.Create;
    LJson.AddPair('itens', LItens);

    TabItens.First;
    while not TabItens.Eof do
    begin
      LItem := TJSONObject.Create;
      LItem.AddPair('produtoID', TabItens.FieldByName('produtoID').AsInteger);
      LItem.AddPair('quantidade', TabItens.FieldByName('quantidade').AsInteger);
      LItens.AddElement(LItem);
      TabItens.Next;
    end;

    try
      LResponse := Enviar('pedidos', LJson, True);
    except
      on E: Exception do
      begin
        ShowMessage('Falha ao salvar o pedido: ' + E.Message);
        Exit;
      end;
    end;
  finally
    LJson.Free;
  end;

  if not (LResponse.StatusCode in [200, 201, 202, 204]) then
  begin
    Falha('salvar o pedido', LResponse);
    Exit;
  end;

  Result := True;
end;

function TfrmCadastrarPedido.GravarEdicao: Boolean;
var
  LJson: TJSONObject;
  LResponse: IResponse;
  LIndice, LItemID, LProdutoID, LQuantidade: Integer;
begin
  Result := False;

  // 1) Cabecalho: cliente e situacao
  LJson := TJSONObject.Create;
  try
    LJson.AddPair('clienteID', ClienteSelecionado);
    LJson.AddPair('situacao', SituacaoSelecionada);
    try
      LResponse := Enviar('pedidos/' + IntToStr(FPedidoID), LJson, False);
    except
      on E: Exception do
      begin
        ShowMessage('Falha ao salvar o pedido: ' + E.Message);
        Exit;
      end;
    end;
  finally
    LJson.Free;
  end;

  if not (LResponse.StatusCode in [200, 201, 202, 204]) then
  begin
    Falha('salvar o pedido', LResponse);
    Exit;
  end;

  // 2) Itens que o usuario removeu da lista
  for LIndice := FItensOriginais.Count - 1 downto 0 do
  begin
    LItemID := StrToIntDef(FItensOriginais[LIndice], 0);
    if (LItemID > 0) and (not ItemNaLista(LItemID)) then
    begin
      try
        LResponse := Excluir('itenspedido/' + IntToStr(LItemID));
      except
        on E: Exception do
        begin
          ShowMessage('Falha ao remover item do pedido: ' + E.Message);
          Exit;
        end;
      end;

      if not (LResponse.StatusCode in [200, 202, 204]) then
      begin
        Falha('remover o item ' + IntToStr(LItemID), LResponse);
        Exit;
      end;

      FItensOriginais.Delete(LIndice);
    end;
  end;

  // 3) Itens novos
  TabItens.DisableControls;
  try
    TabItens.First;
    while not TabItens.Eof do
    begin
      LItemID := TabItens.FieldByName('itemPedidoID').AsInteger;
      if LItemID <= 0 then
      begin
        LProdutoID := TabItens.FieldByName('produtoID').AsInteger;
        LQuantidade := TabItens.FieldByName('quantidade').AsInteger;

        LJson := TJSONObject.Create;
        try
          LJson.AddPair('pedidoID', FPedidoID);
          LJson.AddPair('produtoID', LProdutoID);
          LJson.AddPair('quantidade', LQuantidade);
          try
            LResponse := Enviar('itenspedido', LJson, True);
          except
            on E: Exception do
            begin
              ShowMessage('Falha ao adicionar item: ' + E.Message);
              Exit;
            end;
          end;
        finally
          LJson.Free;
        end;

        if not (LResponse.StatusCode in [200, 201, 202, 204]) then
        begin
          Falha('adicionar item ao pedido', LResponse);
          Exit;
        end;

        // Guarda o id devolvido pela API para nao duplicar em uma nova tentativa
        LItemID := IdDoItem(LResponse.Content);
        if LItemID > 0 then
        begin
          TabItens.Edit;
          TabItens.FieldByName('itemPedidoID').AsInteger := LItemID;
          TabItens.FieldByName('qtdOriginal').AsInteger := LQuantidade;
          TabItens.Post;
          FItensOriginais.Add(IntToStr(LItemID));
        end;
      end;
      TabItens.Next;
    end;
  finally
    TabItens.EnableControls;
  end;

  // 4) Itens com quantidade alterada
  TabItens.DisableControls;
  try
    TabItens.First;
    while not TabItens.Eof do
    begin
      LItemID := TabItens.FieldByName('itemPedidoID').AsInteger;
      LProdutoID := TabItens.FieldByName('produtoID').AsInteger;
      LQuantidade := TabItens.FieldByName('quantidade').AsInteger;

      if (LItemID > 0) and
         (LQuantidade <> TabItens.FieldByName('qtdOriginal').AsInteger) then
      begin
        LJson := TJSONObject.Create;
        try
          LJson.AddPair('produtoID', LProdutoID);
          LJson.AddPair('quantidade', LQuantidade);
          try
            LResponse := Enviar('itenspedido/' + IntToStr(LItemID), LJson, False);
          except
            on E: Exception do
            begin
              ShowMessage('Falha ao atualizar item: ' + E.Message);
              Exit;
            end;
          end;
        finally
          LJson.Free;
        end;

        if not (LResponse.StatusCode in [200, 202, 204]) then
        begin
          Falha('atualizar o item ' + IntToStr(LItemID), LResponse);
          Exit;
        end;

        TabItens.Edit;
        TabItens.FieldByName('qtdOriginal').AsInteger := LQuantidade;
        TabItens.Post;
      end;

      TabItens.Next;
    end;
  finally
    TabItens.EnableControls;
  end;

  Result := True;
end;

end.
