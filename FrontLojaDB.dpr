program FrontLojaDB;

uses
  Vcl.Forms,
  Vcl.Controls,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitDmBase in 'UnitDmBase.pas' {dmBase: TDataModule},
  UnitFrmLogin in 'UnitFrmLogin.pas' {FrmLogin},
  UnitGlobal in 'UnitGlobal.pas',
  UnitFrmCadastrarCategoria in 'forms\UnitFrmCadastrarCategoria.pas' {frmCadastrarCategoria},
  UnitFrmCategorias in 'forms\UnitFrmCategorias.pas' {frmCategorias},
  UnitClientes in 'forms\UnitClientes.pas' {frmClientes},
  UnitCadastrarCliente in 'forms\UnitCadastrarCliente.pas' {frmCadastrarCliente},
  UnitProdutos in 'forms\UnitProdutos.pas' {frmProdutos},
  UnitCadastrarProduto in 'forms\UnitCadastrarProduto.pas' {frmCadastrarProduto},
  UnitPedidos in 'forms\UnitPedidos.pas' {frmPedido},
  UnitCadastrarPedido in 'forms\UnitCadastrarPedido.pas' {frmCadastrarPedido};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
    frmLogin := TfrmLogin.Create(nil);
  try
    if frmLogin.ShowModal <> mrOk then
      Halt;
  finally
    frmLogin.Free;
  end;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TdmBase, dmBase);
  Application.CreateForm(TfrmCadastrarCategoria, frmCadastrarCategoria);
  Application.CreateForm(TfrmCadastrarCliente, frmCadastrarCliente);
  Application.CreateForm(TfrmCadastrarProduto, frmCadastrarProduto);
  Application.CreateForm(TfrmCadastrarPedido, frmCadastrarPedido);
  Application.Run;
end.


end.
