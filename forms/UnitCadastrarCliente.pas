unit UnitCadastrarCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, RESTRequest4D, System.json;

type
  TfrmCadastrarCliente = class(TForm)
    btnSalvar: TButton;
    btnCancelar: TButton;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    edtNome: TLabeledEdit;
    edtEmail: TLabeledEdit;
    edtFone: TLabeledEdit;
    chkAtivo: TCheckBox;
    procedure btnSalvarClick(Sender: TObject);
  private
    { Private declarations }
    FidCliente: integer;
    FDataCadastro: string;
  public
    { Public declarations }
    property IdCliente: Integer read FidCliente write FidCliente;
    property DataCadastro: string read FDataCadastro write FDataCadastro;
  end;

var
  frmCadastrarCliente: TfrmCadastrarCliente;

implementation

{$R *.dfm}

uses UnitGlobal;

procedure TfrmCadastrarCliente.btnSalvarClick(Sender: TObject);
var
  LResponse: IResponse;
  LJson: TJSONObject;
  LAtivo: string;
begin
  if (Trim(edtNome.Text) = '') or (Trim(edtFone.Text) = '') then
  begin
    ShowMessage('Favor informe todos os campos!');
    ModalResult := mrNone;
    Exit;
  end;

  if (Tag = 1) and (FidCliente <= 0) then
  begin
    ShowMessage('Cliente invalido para edicao. Feche e selecione novamente.');
    ModalResult := mrNone;
    Exit;
  end;

  if chkAtivo.Checked then
    LAtivo := 'S'
  else
    LAtivo := 'N';

  LJson := TJSONObject.Create;
  try
    LJson.AddPair('nome', Trim(edtNome.Text));
    LJson.AddPair('email', Trim(edtEmail.Text));
    LJson.AddPair('telefone', Trim(edtFone.Text));
    LJson.AddPair('ativo', LAtivo);

    if Tag = 1 then
    begin
      // A API valida se o id do corpo e igual ao id da URL (senao devolve 400)
      LJson.AddPair('clienteID', FidCliente);
      // A API substitui o registro inteiro no PUT: sem esta data ela vira 0001-01-01
      if FDataCadastro <> '' then
        LJson.AddPair('dataCadastro', FDataCadastro);

      LResponse := TRequest.New
        .BaseURL(URL_API)
        .Resource('clientes/' + IntToStr(FidCliente))
        .Accept('application/json')
        .ContentType('application/json')
        .AddBody(LJson, False)
        .Put;
    end
    else
      LResponse := TRequest.New
        .BaseURL(URL_API)
        .Resource('clientes')
        .Accept('application/json')
        .ContentType('application/json')
        .AddBody(LJson, False)
        .Post;

    if LResponse.StatusCode in [200, 201, 202, 204] then
    begin
//      ShowMessage('Cliente salvo com sucesso!');
      ModalResult := mrOk;
    end
    else
    begin
      ShowMessage('Falha ao salvar: ' + IntToStr(LResponse.StatusCode) + sLineBreak +
        LResponse.Content);
      ModalResult := mrNone;
    end;
  finally
    LJson.Free;
  end;
end;

end.
