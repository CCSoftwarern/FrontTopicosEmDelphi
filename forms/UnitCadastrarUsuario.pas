unit UnitCadastrarUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  RESTRequest4D, System.JSON;

type
  TfrmCadastrarUsuario = class(TForm)
    Panel1: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    GroupBox1: TGroupBox;
    edtNome: TLabeledEdit;
    edtEmail: TLabeledEdit;
    edtSenha: TLabeledEdit;
    lblTipo: TLabel;
    cbTipo: TComboBox;
    chkAtivo: TCheckBox;
    lblAviso: TLabel;
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FUsuarioId: Integer;
    FNome: string;
    FEmail: string;
    FTipo: Integer;
    FAtivo: Boolean;
    FPasswordHash: string;
    function TipoSelecionado: Integer;
    function EmailValido(const AEmail: string): Boolean;
    function MensagemResposta(AResponse: IResponse): string;
    function CriarUsuario: Boolean;
    function AtivarUsuario(AUsuarioId: Integer): Boolean;
    function AlterarUsuario: Boolean;
  public
    property UsuarioId: Integer read FUsuarioId write FUsuarioId;
    property Nome: string read FNome write FNome;
    property Email: string read FEmail write FEmail;
    property Tipo: Integer read FTipo write FTipo;
    property Ativo: Boolean read FAtivo write FAtivo;
    property PasswordHash: string read FPasswordHash write FPasswordHash;
  end;

var
  frmCadastrarUsuario: TfrmCadastrarUsuario;

implementation

{$R *.dfm}

uses UnitGlobal;

function IdDoUsuario(const AConteudo: string): Integer;
var
  LJson: TJSONValue;
begin
  Result := 0;
  LJson := TJSONObject.ParseJSONValue(AConteudo);
  try
    if (LJson <> nil) and (LJson is TJSONObject) then
      if TJSONObject(LJson).GetValue('id') is TJSONNumber then
        Result := (TJSONObject(LJson).GetValue('id') as TJSONNumber).AsInt;
  finally
    LJson.Free;
  end;
end;

{ TfrmCadastrarUsuario }

procedure TfrmCadastrarUsuario.FormShow(Sender: TObject);
begin
  if FUsuarioId > 0 then
  begin
    Caption := 'Editar usu'#225'rio';
    edtNome.Text := FNome;
    edtEmail.Text := FEmail;

    if FTipo = 2 then
      cbTipo.ItemIndex := 1
    else
      cbTipo.ItemIndex := 0;

    // O PUT da API nao altera o tipo nem aplica hash na senha.
    cbTipo.Enabled := False;
    lblAviso.Visible := True;

    edtSenha.Text := '';
    edtSenha.Enabled := False;
    edtSenha.EditLabel.Caption := 'Senha (mantida)';

    chkAtivo.Checked := FAtivo;
  end
  else
  begin
    Caption := 'Novo usu'#225'rio';
    edtNome.Clear;
    edtEmail.Clear;
    edtSenha.Clear;
    edtSenha.Enabled := True;
    edtSenha.EditLabel.Caption := 'Senha';
    cbTipo.Enabled := True;
    cbTipo.ItemIndex := 0;
    lblAviso.Visible := False;
    chkAtivo.Checked := True;
  end;

  if (FUsuarioId <= 0) and edtNome.CanFocus then
    edtNome.SetFocus;
end;

function TfrmCadastrarUsuario.TipoSelecionado: Integer;
begin
  if cbTipo.ItemIndex = 1 then
    Result := 2
  else
    Result := 1;
end;

function TfrmCadastrarUsuario.EmailValido(const AEmail: string): Boolean;
var
  LEmail: string;
  LArroba, LPonto: Integer;
begin
  LEmail := Trim(AEmail);
  LArroba := Pos('@', LEmail);
  LPonto := LastDelimiter('.', LEmail);
  Result := (LArroba > 1) and (LPonto > LArroba + 1) and (LPonto < Length(LEmail));
end;

function TfrmCadastrarUsuario.MensagemResposta(AResponse: IResponse): string;
var
  LJson: TJSONValue;
  LTexto: string;
begin
  LTexto := Trim(AResponse.Content);
  if LTexto = '' then
    Exit('Sem detalhes do servidor.');

  LJson := TJSONObject.ParseJSONValue(LTexto);
  try
    if (LJson <> nil) and (LJson is TJSONObject) then
    begin
      if TJSONObject(LJson).GetValue('message') <> nil then
        Exit(TJSONObject(LJson).GetValue('message').Value);
      if TJSONObject(LJson).GetValue('title') <> nil then
        Exit(TJSONObject(LJson).GetValue('title').Value);
    end;
  finally
    LJson.Free;
  end;

  // Erros nao tratados da API vem como texto longo; mostramos so o inicio.
  if Length(LTexto) > 300 then
    LTexto := Copy(LTexto, 1, 300) + '...';
  Result := LTexto;
end;

function TfrmCadastrarUsuario.CriarUsuario: Boolean;
var
  LJson: TJSONObject;
  LResponse: IResponse;
  LNovoId: Integer;
begin
  Result := False;

  LJson := TJSONObject.Create;
  try
    LJson.AddPair('email', Trim(edtEmail.Text));
    // A API recebe a senha em texto neste campo e aplica o hash BCrypt.
    LJson.AddPair('password_hash', edtSenha.Text);
    LJson.AddPair('name', Trim(edtNome.Text));
    // A API nao inclui "active = true" no INSERT (valor default do modelo),
    // entao o usuario e criado inativo e ativado no passo seguinte.
    LJson.AddPair('active', False);
    LJson.AddPair('tipo', TipoSelecionado);

    try
      LResponse := TRequest.New
        .BaseURL(URL_API)
        .Resource('users')
        .Accept('application/json')
        .ContentType('application/json')
        .AddBody(LJson, False)
        .Post;
    except
      on E: Exception do
      begin
        ShowMessage('Falha ao incluir o usu'#225'rio: ' + E.Message);
        Exit;
      end;
    end;
  finally
    LJson.Free;
  end;

  if not (LResponse.StatusCode in [200, 201, 202, 204]) then
  begin
    ShowMessage('Falha ao incluir o usu'#225'rio (' +
      IntToStr(LResponse.StatusCode) + ').' + sLineBreak +
      MensagemResposta(LResponse));
    Exit;
  end;

  LNovoId := IdDoUsuario(LResponse.Content);

  if chkAtivo.Checked then
  begin
    if (LNovoId <= 0) or (not AtivarUsuario(LNovoId)) then
    begin
      ShowMessage('O usu'#225'rio foi criado, mas n'#227'o foi poss'#237'vel ativ'#225'-lo.' +
        sLineBreak + 'Use a op'#231#227'o Editar para ativ'#225'-lo.');
    end;
  end;

  Result := True;
end;

function TfrmCadastrarUsuario.AtivarUsuario(AUsuarioId: Integer): Boolean;
var
  LConsulta, LAlteracao: IResponse;
  LJson: TJSONValue;
  LObj, LBody: TJSONObject;
  LHash: string;
begin
  Result := False;

  try
    LConsulta := TRequest.New
      .BaseURL(URL_API)
      .Resource('users/' + IntToStr(AUsuarioId))
      .Accept('application/json')
      .Get;
  except
    Exit;
  end;

  if LConsulta.StatusCode <> 200 then
    Exit;

  LHash := '';
  LJson := TJSONObject.ParseJSONValue(LConsulta.Content);
  try
    if (LJson <> nil) and (LJson is TJSONObject) then
    begin
      LObj := TJSONObject(LJson);
      if LObj.GetValue('password_hash') <> nil then
        LHash := LObj.GetValue('password_hash').Value;
    end;
  finally
    LJson.Free;
  end;

  if LHash = '' then
    Exit;

  LBody := TJSONObject.Create;
  try
    LBody.AddPair('id', AUsuarioId);
    LBody.AddPair('email', Trim(edtEmail.Text));
    LBody.AddPair('password_hash', LHash);
    LBody.AddPair('name', Trim(edtNome.Text));
    LBody.AddPair('active', True);
    LBody.AddPair('tipo', TipoSelecionado);

    try
      LAlteracao := TRequest.New
        .BaseURL(URL_API)
        .Resource('users/' + IntToStr(AUsuarioId))
        .Accept('application/json')
        .ContentType('application/json')
        .AddBody(LBody, False)
        .Put;
    except
      Exit;
    end;
  finally
    LBody.Free;
  end;

  Result := LAlteracao.StatusCode in [200, 202, 204];
end;

function TfrmCadastrarUsuario.AlterarUsuario: Boolean;
var
  LJson: TJSONObject;
  LResponse: IResponse;
begin
  Result := False;

  if FPasswordHash = '' then
  begin
    ShowMessage('N'#227'o foi poss'#237'vel obter os dados do usu'#225'rio.' +
      sLineBreak + 'Feche a tela e selecione o usu'#225'rio novamente.');
    Exit;
  end;

  if (FUsuarioId = UsuarioLogadoId) and (not chkAtivo.Checked) then
  begin
    ShowMessage('Voc'#234' n'#227'o pode desativar o pr'#243'prio usu'#225'rio.');
    Exit;
  end;

  LJson := TJSONObject.Create;
  try
    LJson.AddPair('id', FUsuarioId);
    LJson.AddPair('email', Trim(edtEmail.Text));
    // Sem o hash atual o login do usuario seria quebrado (o PUT nao faz hash).
    LJson.AddPair('password_hash', FPasswordHash);
    LJson.AddPair('name', Trim(edtNome.Text));
    LJson.AddPair('active', chkAtivo.Checked);
    LJson.AddPair('tipo', TipoSelecionado);

    try
      LResponse := TRequest.New
        .BaseURL(URL_API)
        .Resource('users/' + IntToStr(FUsuarioId))
        .Accept('application/json')
        .ContentType('application/json')
        .AddBody(LJson, False)
        .Put;
    except
      on E: Exception do
      begin
        ShowMessage('Falha ao salvar o usu'#225'rio: ' + E.Message);
        Exit;
      end;
    end;
  finally
    LJson.Free;
  end;

  if LResponse.StatusCode in [200, 202, 204] then
    Result := True
  else
    ShowMessage('Falha ao salvar o usu'#225'rio (' +
      IntToStr(LResponse.StatusCode) + ').' + sLineBreak +
      MensagemResposta(LResponse));
end;

procedure TfrmCadastrarUsuario.btnSalvarClick(Sender: TObject);
var
  LOk: Boolean;
begin
  if Trim(edtNome.Text) = '' then
  begin
    ShowMessage('Informe o nome do usu'#225'rio.');
    ModalResult := mrNone;
    if edtNome.CanFocus then
      edtNome.SetFocus;
    Exit;
  end;

  if not EmailValido(edtEmail.Text) then
  begin
    ShowMessage('Informe um e-mail v'#225'lido.');
    ModalResult := mrNone;
    if edtEmail.CanFocus then
      edtEmail.SetFocus;
    Exit;
  end;

  if FUsuarioId <= 0 then
  begin
    if Length(Trim(edtSenha.Text)) < 6 then
    begin
      ShowMessage('A senha deve ter pelo menos 6 caracteres.');
      ModalResult := mrNone;
      if edtSenha.CanFocus then
        edtSenha.SetFocus;
      Exit;
    end;

    LOk := CriarUsuario;
  end
  else
    LOk := AlterarUsuario;

  if not LOk then
    ModalResult := mrNone;
end;

end.
