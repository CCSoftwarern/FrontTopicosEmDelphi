unit UnitClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.ImageList, Vcl.ImgList, cxImageList, cxGraphics,
  System.Actions, Vcl.ActnList, dxBar, cxClasses, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  cxDBData, cxCheckBox, cxButtonEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, Vcl.StdCtrls,  RESTRequest4D;

type
  TfrmClientes = class(TForm)
    BarraClientes: TdxBarManager;
    BarraCategoriasBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    acoesMenuClientes: TActionList;
    acNovoCliente: TAction;
    acCarregar: TAction;
    img24x24: TcxImageList;
    RESTClientClientes: TRESTClient;
    RESTRequestClientes: TRESTRequest;
    RESTResponseClientes: TRESTResponse;
    RESTResponseDataSetAdapterClientes: TRESTResponseDataSetAdapter;
    TabClientes: TFDMemTable;
    DataSourceClientes: TDataSource;
    acoesGridClientes: TActionList;
    acEditar: TAction;
    acExcluir: TAction;
    cxGridClientes: TcxGrid;
    cxGridClientesDBTableViewClientes: TcxGridDBTableView;
    cxGridClientesLevel1: TcxGridLevel;
    cxGridClientesDBTableViewClientesclienteID: TcxGridDBColumn;
    cxGridClientesDBTableViewClientesnome: TcxGridDBColumn;
    cxGridClientesDBTableViewClientesemail: TcxGridDBColumn;
    cxGridClientesDBTableViewClientestelefone: TcxGridDBColumn;
    cxGridClientesDBTableViewClientesdataCadastro: TcxGridDBColumn;
    cxGridClientesDBTableViewClientesativo: TcxGridDBColumn;
    cxGridClientesDBTableViewClientespedidos: TcxGridDBColumn;
    cxGridClientesDBTableViewClientesColumn1: TcxGridDBColumn;
    procedure acCarregarExecute(Sender: TObject);
    procedure acEditarExecute(Sender: TObject);
    procedure acNovoClienteExecute(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

{$R *.dfm}

uses UnitMain, UnitCadastrarCliente, UnitGlobal;

procedure TfrmClientes.acCarregarExecute(Sender: TObject);
begin
RESTRequestClientes.Execute;
end;

procedure TfrmClientes.acEditarExecute(Sender: TObject);
begin
  if TabClientes.IsEmpty then
  begin
    ShowMessage('Selecione um cliente para editar.');
    Exit;
  end;

  with frmCadastrarCliente do begin
    Tag:= 1;
    IdCliente:= TabClientes.FieldByName('clienteID').AsInteger;
    edtNome.Text:= TabClientes.FieldByName('nome').AsString;
    edtEmail.Text:= TabClientes.FieldByName('email').AsString;
    edtFone.Text:= TabClientes.FieldByName('telefone').AsString;
    DataCadastro:= TabClientes.FieldByName('dataCadastro').AsString;
    chkAtivo.Checked := TabClientes.FieldByName('ativo').AsString = 'S';
    ShowModal;
  end;

  acCarregar.Execute;
end;

procedure TfrmClientes.acExcluirExecute(Sender: TObject);
var
  LResponse: IResponse;
  id: string;
begin
  if TabClientes.IsEmpty then
  begin
    ShowMessage('Selecione uma categoria para excluir.');
    Exit;
  end;

  id:= TabClientes.FieldByName('ClienteID').AsString;

  LResponse := TRequest.New
    .BaseURL(URL_API)
    .Resource('Clientes/'+id)
    .Accept('application/json')
    .Delete;
  if LResponse.StatusCode in [200, 202, 204] then
  begin
  acCarregar.Execute;
  end

  else
    ShowMessage('Falha: ' + IntToStr(LResponse.StatusCode));
end;

procedure TfrmClientes.acNovoClienteExecute(Sender: TObject);
begin
  with frmCadastrarCliente do begin
   Tag:= 0;
   IdCliente:= 0;
   DataCadastro:= '';
   edtNome.Clear;
   edtEmail.Clear;
   edtFone.Clear;
   chkAtivo.Checked := True;
   ShowModal;
  end;

  acCarregar.Execute;
end;

end.
