unit UnitFrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSON;

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

uses UnitGlobal;

procedure TFrmLogin.Button2Click(Sender: TObject);
var
  Json: string;
  JsonVal: TJSONValue;
  JsonObj: TJSONObject;
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

  // Verifica se veio conteúdo válido
  if Trim(RESTResponseLogin.Content) = '' then
  begin
    ShowMessage('Resposta vazia do servidor.');
    Exit;
  end;

  JsonVal := TJSONObject.ParseJSONValue(RESTResponseLogin.Content);
  if not Assigned(JsonVal) then
  begin
    ShowMessage('Resposta JSON inválida do servidor.');
    Exit;
  end;

  try
    if not (JsonVal is TJSONObject) then
    begin
      ShowMessage('Formato de resposta inesperado.');
      Exit;
    end;

    JsonObj := TJSONObject(JsonVal);

    UsuarioLogadoId   := JsonObj.GetValue<Integer>('id');
    UsuarioLogadoNome := JsonObj.GetValue('name').Value;
    UsuarioLogadoTipo := JsonObj.GetValue<Integer>('tipo');

    ModalResult := mrOk;
  finally
    JsonVal.Free;
  end;
end;

end.
