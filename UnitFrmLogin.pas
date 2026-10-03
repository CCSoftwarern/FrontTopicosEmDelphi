unit UnitFrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TFrmLogin = class(TForm)
    Bevel1: TBevel;
    Button2: TButton;
    edtEmail: TLabeledEdit;
    edtSenha: TLabeledEdit;
    RESTClientLogin: TRESTClient;
    RESTRequestLogin: TRESTRequest;
    RESTResponseLogin: TRESTResponse;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

procedure TFrmLogin.Button2Click(Sender: TObject);
var
  Json: string;
begin
  if (edtEmail.Text = '') or (edtSenha.Text = '') then
  begin
    ShowMessage('Informe e-mail e senha!');
    Exit;
  end;

  RESTRequestLogin.ClearBody;

  Json := '{' +
          '"email":"' + Trim(edtEmail.Text) + '",' +
          '"password":"' + edtSenha.Text + '"' +
          '}';

  RESTRequestLogin.AddBody(Json, ctAPPLICATION_JSON);
  RESTRequestLogin.Execute;

  if RESTResponseLogin.StatusCode <> 200 then
  begin
    ShowMessage('E-mail ou senha inválidos.');
    edtSenha.Clear;
    edtSenha.SetFocus;
    Exit;
  end;

  ModalResult := mrOk;
end;

end.
