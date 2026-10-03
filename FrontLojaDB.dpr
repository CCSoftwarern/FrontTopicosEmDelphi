program FrontLojaDB;

uses
  Vcl.Forms, Vcl.Controls,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitDmBase in 'UnitDmBase.pas' {dmBase: TDataModule},
  UnitFrmLogin in 'UnitFrmLogin.pas' {FrmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
    frmLogin := TfrmLogin.Create(nil);
  try
    if frmLogin.ShowModal <> mrOk then
      Halt; // Sai se cancelar
  finally
    frmLogin.Free;
  end;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TdmBase, dmBase);
  Application.Run;
end.


end.
