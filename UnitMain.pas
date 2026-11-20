unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Mask, Vcl.ExtCtrls,  REST.Client, System.JSON, REST.Types,
  JvExControls, JvOutlookBar, AdvNavBar, System.ImageList, Vcl.ImgList,
  cxImageList, cxGraphics, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxNavBar, dxNavBarGroupItems, dxNavBarCollns,
  cxClasses, dxNavBarBase, dxBarBuiltInMenu, cxPC, IdBaseComponent,
  IdAntiFreezeBase, IdAntiFreeze, System.UITypes;

type
  TFormMain = class(TForm)
    Acoes: TActionManager;
    acCadastroClientes: TAction;
    img32x32: TcxImageList;
    navBar: TdxNavBar;
    navBarGroup1: TdxNavBarGroup;
    navBarItemClientes: TdxNavBarItem;
    acCategorias: TAction;
    acProdutos: TAction;
    navBarItemCategorias: TdxNavBarItem;
    navBarItemProdutos: TdxNavBarItem;
    navBarSeparator1: TdxNavBarSeparator;
    navBarItemPedidos: TdxNavBarItem;
    acPedidos: TAction;
    acUsuarios: TAction;
    navBarSeparator2: TdxNavBarSeparator;
    navBarItemUsuarios: TdxNavBarItem;
    acSair: TAction;
    navBarSeparator3: TdxNavBarSeparator;
    navBarItem1: TdxNavBarItem;
    PageControlOperacoes: TcxPageControl;
    img16x16: TcxImageList;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure acCategoriasExecute(Sender: TObject);
    procedure PageControlOperacoesCanCloseEx(Sender: TObject;
      ATabIndex: Integer; var ACanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure acCadastroClientesExecute(Sender: TObject);
    procedure acProdutosExecute(Sender: TObject);
    procedure acPedidosExecute(Sender: TObject);
    procedure acUsuariosExecute(Sender: TObject);
    procedure acSairExecute(Sender: TObject);

  private
    { Private declarations }
    function  AcharAba(AFormClass: TFormClass): TcxTabSheet;
  procedure NovaAba(AFormClass: TFormClass; const ACaption: string;
      AFechar: Boolean; const AURL: string = ''; AImageIndex: Integer = -1);

  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses UnitDmBase, UnitGlobal, UnitFrmCategorias, UnitClientes, UnitProdutos,
  UnitPedidos, UnitUsuarios, UnitFrmLogin;



{ TFormMain }

procedure TFormMain.acCadastroClientesExecute(Sender: TObject);
begin
 NovaAba(TFrmClientes, 'Clientes', True, '', 1);
end;

procedure TFormMain.acCategoriasExecute(Sender: TObject);
begin
 NovaAba(TFrmCategorias, 'Categorias', True, '', 1);
end;

function TFormMain.AcharAba(AFormClass: TFormClass): TcxTabSheet;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to PageControlOperacoes.PageCount - 1 do
    if PageControlOperacoes.Pages[I].Tag = NativeInt(AFormClass) then
      Exit(PageControlOperacoes.Pages[I]);
end;





procedure TFormMain.acPedidosExecute(Sender: TObject);
begin
 NovaAba(TfrmPedido, 'Pedidos', True, '', 1);
end;

procedure TFormMain.acUsuariosExecute(Sender: TObject);
begin
  if UsuarioLogadoTipo <> 2 then
  begin
    ShowMessage('Acesso restrito a administradores.');
    Exit;
  end;

  NovaAba(TfrmUsuarios, 'Usu'#225'rios', True, '', 1);
end;

procedure TFormMain.acSairExecute(Sender: TObject);
var
  LLogin: TFrmLogin;
  LEntrou: Boolean;
begin
  if MessageDlg('Deseja sair do sistema?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  // Encerra a sessao atual: fecha as abas abertas e limpa o usuario logado.
  while PageControlOperacoes.PageCount > 0 do
    PageControlOperacoes.CloseTab(PageControlOperacoes.PageCount - 1);

  UsuarioLogadoId := 0;
  UsuarioLogadoNome := '';
  UsuarioLogadoTipo := 0;

  Hide;
  LLogin := TFrmLogin.Create(nil);
  try
    LEntrou := LLogin.ShowModal = mrOk;
  finally
    LLogin.Free;
  end;

  if LEntrou then
  begin
    Caption := 'LojaDb - ' + UsuarioLogadoNome;
    Show;
  end
  else
    Application.Terminate;
end;

procedure TFormMain.acProdutosExecute(Sender: TObject);
begin
 NovaAba(TFrmProdutos, 'Produtos', True, '', 1);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
Caption:= 'LojaDb - '+ UsuarioLogadoNome;
end;

procedure TFormMain.NovaAba(AFormClass: TFormClass; const ACaption: string;
  AFechar: Boolean; const AURL: string; AImageIndex: Integer);
var
  Aba: TcxTabSheet;
  Form: TForm;
begin
  Aba := AcharAba(AFormClass);
  if Aba <> nil then
  begin
    PageControlOperacoes.ActivePage := Aba;
    Exit;
  end;

  Aba := TcxTabSheet.Create(PageControlOperacoes);
  try
    Aba.PageControl      := PageControlOperacoes;
    Aba.Caption          := ACaption;
    Aba.AllowCloseButton := AFechar;
    Aba.ImageIndex       := AImageIndex;
    Aba.Tag              := NativeInt(AFormClass);

    Form := AFormClass.Create(Aba);
    Form.BorderStyle := bsNone;
    Form.Align       := alClient;
    Form.Parent      := Aba;
    Form.Show;

    PageControlOperacoes.ActivePage := Aba;


  except
    Aba.Free;
    raise;
  end;
end;

procedure TFormMain.PageControlOperacoesCanCloseEx(Sender: TObject;
  ATabIndex: Integer; var ACanClose: Boolean);
begin
ACanClose := True;
end;

end.
