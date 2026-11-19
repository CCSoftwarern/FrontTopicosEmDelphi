unit UnitFrmCadastrarCategoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, RESTRequest4D, System.json;

type
  TfrmCadastrarCategoria = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    edtNome: TLabeledEdit;
    Label1: TLabel;
    mmDescricao: TMemo;
    chkAtivo: TCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FIdCategoria: Integer;
  public
    { Public declarations }
    property IdCategoria: Integer read FIdCategoria write FIdCategoria;
  end;

var
  frmCadastrarCategoria: TfrmCadastrarCategoria;

implementation

{$R *.dfm}

uses UnitGlobal;

procedure TfrmCadastrarCategoria.Button1Click(Sender: TObject);
var
  LResponse: IResponse;
  LJson: TJSONObject;
  LAtivo: string;
begin
  if (Trim(edtNome.Text) = '') or (Trim(mmDescricao.Text) = '') then
  begin
    ShowMessage('Favor informe todos os campos!');
    ModalResult := mrNone;
    Exit;
  end;

  if (Tag = 1) and (FIdCategoria <= 0) then
  begin
    ShowMessage('Categoria invalida para edicao. Feche e selecione novamente.');
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
    LJson.AddPair('descricao', Trim(mmDescricao.Text));
    LJson.AddPair('ativo', LAtivo);

    if Tag = 1 then
    begin
      LJson.AddPair('categoriaID', FIdCategoria);
      LResponse := TRequest.New
        .BaseURL(URL_API)
        .Resource('Categorias/' + IntToStr(FIdCategoria))
        .Accept('application/json')
        .ContentType('application/json')
        .AddBody(LJson, False)
        .Put;
    end
    else
      LResponse := TRequest.New
        .BaseURL(URL_API)
        .Resource('Categorias')
        .Accept('application/json')
        .ContentType('application/json')
        .AddBody(LJson, False)
        .Post;

    if LResponse.StatusCode in [200, 201, 202, 204] then
    begin
      ShowMessage('Categoria salva com sucesso!');
      ModalResult := mrOk;
    end
    else
    begin
      ShowMessage('Falha: ' + IntToStr(LResponse.StatusCode) + sLineBreak +
        LResponse.Content);
      ModalResult := mrNone;
    end;
  finally
    LJson.Free;
  end;
end;

end.
