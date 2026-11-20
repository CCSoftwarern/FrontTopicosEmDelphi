unit UnitUsuarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, System.ImageList, Vcl.ImgList,
  cxImageList, cxGraphics, System.Actions, Vcl.ActnList, dxBar, cxClasses,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, cxDBData, cxCheckBox, cxButtonEdit, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, Vcl.StdCtrls, RESTRequest4D, System.JSON, System.UITypes;

type
  TfrmUsuarios = class(TForm)
    BarraUsuarios: TdxBarManager;
    BarraUsuariosBar1: TdxBar;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton1: TdxBarLargeButton;
    acoesMenuUsuarios: TActionList;
    acNovoUsuario: TAction;
    acCarregar: TAction;
    img24x24: TcxImageList;
    RESTClientUsuarios: TRESTClient;
    RESTRequestUsuarios: TRESTRequest;
    RESTResponseUsuarios: TRESTResponse;
    RESTResponseDataSetAdapterUsuarios: TRESTResponseDataSetAdapter;
    TabUsuarios: TFDMemTable;
    DataSourceUsuarios: TDataSource;
    acoesGridUsuarios: TActionList;
    acEditar: TAction;
    acExcluir: TAction;
    cxGridUsuarios: TcxGrid;
    cxGridUsuariosDBTableViewUsuarios: TcxGridDBTableView;
    cxGridUsuariosDBTableViewUsuariosid: TcxGridDBColumn;
    cxGridUsuariosDBTableViewUsuariosnome: TcxGridDBColumn;
    cxGridUsuariosDBTableViewUsuariosemail: TcxGridDBColumn;
    cxGridUsuariosDBTableViewUsuariostipo: TcxGridDBColumn;
    cxGridUsuariosDBTableViewUsuariosativo: TcxGridDBColumn;
    cxGridUsuariosDBTableViewUsuariosColumn1: TcxGridDBColumn;
    cxGridUsuariosLevel1: TcxGridLevel;
    procedure acCarregarExecute(Sender: TObject);
    procedure acNovoUsuarioExecute(Sender: TObject);
    procedure acEditarExecute(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
  private
    procedure AjustarColunas;
    procedure AbrirCadastro(AUsuarioId: Integer);
    function UsuarioSelecionado: Integer;
    function UsuarioSelecionadoAtivo: Boolean;
    procedure NomeGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TipoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure AtivoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  public
    { Public declarations }
  end;

var
  frmUsuarios: TfrmUsuarios;

implementation

{$R *.dfm}

uses UnitMain, UnitGlobal, UnitCadastrarUsuario;

function ValorVerdadeiro(const ATexto: string): Boolean;
var
  LTexto: string;
begin
  LTexto := Trim(ATexto);
  Result := SameText(LTexto, 'T') or SameText(LTexto, 'true') or
    SameText(LTexto, 'sim') or (LTexto = '1');
end;

procedure TfrmUsuarios.acCarregarExecute(Sender: TObject);
begin
  try
    RESTRequestUsuarios.Execute;
    AjustarColunas;
  except
    on E: Exception do
      ShowMessage('N'#227'o foi poss'#237'vel carregar os usu'#225'rios.' +
        sLineBreak + E.Message);
  end;
end;

procedure TfrmUsuarios.AjustarColunas;
var
  LField: TField;
begin
  // O adaptador recria os campos a cada carga, entao religamos a formatacao.
  LField := TabUsuarios.FindField('name');
  if LField <> nil then
    LField.OnGetText := NomeGetText;

  LField := TabUsuarios.FindField('tipo');
  if LField <> nil then
    LField.OnGetText := TipoGetText;

  LField := TabUsuarios.FindField('active');
  if LField <> nil then
    LField.OnGetText := AtivoGetText;
end;

procedure TfrmUsuarios.NomeGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := Trim(Sender.AsString);
  if Text = '' then
    Text := '(sem nome)';
end;

procedure TfrmUsuarios.TipoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if StrToIntDef(Trim(Sender.AsString), 1) = 2 then
    Text := 'Administrador'
  else
    Text := 'Padr'#227'o';
end;

procedure TfrmUsuarios.AtivoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if ValorVerdadeiro(Sender.AsString) then
    Text := 'Sim'
  else
    Text := 'N'#227'o';
end;

function TfrmUsuarios.UsuarioSelecionado: Integer;
begin
  if TabUsuarios.IsEmpty then
    Result := 0
  else
    Result := StrToIntDef(Trim(TabUsuarios.FieldByName('id').AsString), 0);
end;

function TfrmUsuarios.UsuarioSelecionadoAtivo: Boolean;
begin
  Result := (not TabUsuarios.IsEmpty) and
    ValorVerdadeiro(TabUsuarios.FieldByName('active').AsString);
end;

procedure TfrmUsuarios.acNovoUsuarioExecute(Sender: TObject);
begin
  AbrirCadastro(0);
end;

procedure TfrmUsuarios.acEditarExecute(Sender: TObject);
begin
  if UsuarioSelecionado <= 0 then
  begin
    ShowMessage('Selecione um usu'#225'rio para editar.');
    Exit;
  end;

  AbrirCadastro(UsuarioSelecionado);
end;

procedure TfrmUsuarios.AbrirCadastro(AUsuarioId: Integer);
begin
  with frmCadastrarUsuario do
  begin
    UsuarioId := 0;
    Nome := '';
    Email := '';
    Tipo := 1;
    Ativo := True;
    PasswordHash := '';

    if AUsuarioId > 0 then
    begin
      UsuarioId := AUsuarioId;
      Nome := TabUsuarios.FieldByName('name').AsString;
      Email := TabUsuarios.FieldByName('email').AsString;
      Tipo := StrToIntDef(Trim(TabUsuarios.FieldByName('tipo').AsString), 1);
      Ativo := ValorVerdadeiro(TabUsuarios.FieldByName('active').AsString);
      PasswordHash := TabUsuarios.FieldByName('password_hash').AsString;
    end;

    if ShowModal = mrOk then
      acCarregar.Execute;
  end;
end;

procedure TfrmUsuarios.acExcluirExecute(Sender: TObject);
var
  LId: Integer;
  LNome: string;
  LJson: TJSONObject;
  LResponse: IResponse;
begin
  LId := UsuarioSelecionado;
  if LId <= 0 then
  begin
    ShowMessage('Selecione um usu'#225'rio para excluir.');
    Exit;
  end;

  if LId = UsuarioLogadoId then
  begin
    ShowMessage('Voc'#234' n'#227'o pode excluir o pr'#243'prio usu'#225'rio.');
    Exit;
  end;

  if not UsuarioSelecionadoAtivo then
  begin
    ShowMessage('Este usu'#225'rio j'#225' est'#225' inativo.');
    Exit;
  end;

  LNome := TabUsuarios.FieldByName('name').AsString;
  if LNome = '' then
    LNome := TabUsuarios.FieldByName('email').AsString;

  if MessageDlg('Excluir o usu'#225'rio "' + LNome + '"?' + sLineBreak +
    'Ele ser'#225' desativado e n'#227'o poder'#225' mais entrar no sistema.',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  // A API nao possui DELETE: a exclusao e feita desativando o usuario.
  // O PUT substitui o registro inteiro, entao reenviamos os dados atuais
  // (inclusive o hash da senha) com active = false.
  LJson := TJSONObject.Create;
  try
    LJson.AddPair('id', LId);
    LJson.AddPair('email', TabUsuarios.FieldByName('email').AsString);
    LJson.AddPair('password_hash', TabUsuarios.FieldByName('password_hash').AsString);
    LJson.AddPair('name', TabUsuarios.FieldByName('name').AsString);
    LJson.AddPair('active', False);
    LJson.AddPair('tipo', StrToIntDef(Trim(TabUsuarios.FieldByName('tipo').AsString), 1));

    try
      LResponse := TRequest.New
        .BaseURL(URL_API)
        .Resource('users/' + IntToStr(LId))
        .Accept('application/json')
        .ContentType('application/json')
        .AddBody(LJson, False)
        .Put;
    except
      on E: Exception do
      begin
        ShowMessage('Falha ao excluir o usu'#225'rio: ' + E.Message);
        Exit;
      end;
    end;
  finally
    LJson.Free;
  end;

  if LResponse.StatusCode in [200, 202, 204] then
    acCarregar.Execute
  else
    ShowMessage('Falha ao excluir o usu'#225'rio (' +
      IntToStr(LResponse.StatusCode) + ').' + sLineBreak +
      Trim(LResponse.Content));
end;

end.
