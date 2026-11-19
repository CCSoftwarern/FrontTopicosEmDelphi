unit UnitFrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSON;

type
  TFrmLogin = class(TForm)
    pnlMarca: TPanel;
    pnlAcento: TPanel;
    lblMarca: TLabel;
    lblSlogan: TLabel;
    lblAcessoRestrito: TLabel;
    pnlLogin: TPanel;
    lblBoasVindas: TLabel;
    lblSubtitulo: TLabel;
    lblEmail: TLabel;
    edtEmail: TEdit;
    lblSenha: TLabel;
    edtSenha: TEdit;
    chkMostrarSenha: TCheckBox;
    btnEntrar: TButton;
    lblErro: TLabel;
    RESTClientLogin: TRESTClient;
    RESTRequestLogin: TRESTRequest;
    RESTResponseLogin: TRESTResponse;
    procedure btnEntrarClick(Sender: TObject);
    procedure chkMostrarSenhaClick(Sender: TObject);
  private
    procedure MostrarErro(const AMensagem: string);
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses UnitGlobal;

procedure TFrmLogin.MostrarErro(const AMensagem: string);
begin
  lblErro.Caption := AMensagem;
  lblErro.Visible := AMensagem <> '';
end;

procedure TFrmLogin.chkMostrarSenhaClick(Sender: TObject);
begin
  if chkMostrarSenha.Checked then
    edtSenha.PasswordChar := #0
  else
    edtSenha.PasswordChar := '*';
end;

procedure TFrmLogin.btnEntrarClick(Sender: TObject);
var
  Json: string;
  JsonVal: TJSONValue;
  JsonObj: TJSONObject;
begin
  MostrarErro('');

  if (Trim(edtEmail.Text) = '') or (edtSenha.Text = '') then
  begin
    MostrarErro('Informe e-mail e senha.');
    if Trim(edtEmail.Text) = '' then
      edtEmail.SetFocus
    else
      edtSenha.SetFocus;
    Exit;
  end;

  RESTRequestLogin.ClearBody;

  Json := '{' +
          '"email":"' + Trim(edtEmail.Text) + '",' +
          '"password":"' + edtSenha.Text + '"' +
          '}';

  RESTRequestLogin.AddBody(Json, ctAPPLICATION_JSON);

  try
    RESTRequestLogin.Execute;
  except
    MostrarErro('N'#227'o foi poss'#237'vel conectar ao servidor.');
    Exit;
  end;

  if RESTResponseLogin.StatusCode <> 200 then
  begin
    MostrarErro('E-mail ou senha inv'#225'lidos.');
    edtSenha.Clear;
    edtSenha.SetFocus;
    Exit;
  end;

  // Verifica se veio conteudo valido
  if Trim(RESTResponseLogin.Content) = '' then
  begin
    MostrarErro('Resposta vazia do servidor.');
    Exit;
  end;

  JsonVal := TJSONObject.ParseJSONValue(RESTResponseLogin.Content);
  if not Assigned(JsonVal) then
  begin
    MostrarErro('Resposta JSON inv'#225'lida do servidor.');
    Exit;
  end;

  try
    if not (JsonVal is TJSONObject) then
    begin
      MostrarErro('Formato de resposta inesperado.');
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
