unit UnitCadastrarProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, Vcl.Samples.Spin, cxCurrencyEdit, Vcl.Mask, RESTRequest4D, System.json;

type
  TfrmCadastrarProduto = class(TForm)
    GroupBox1: TGroupBox;
    btnSalvar: TButton;
    btnCancelar: TButton;
    Panel1: TPanel;
    comboCategoria: TcxLookupComboBox;
    Label1: TLabel;
    edtNome: TLabeledEdit;
    Label2: TLabel;
    mmDescricao: TMemo;
    edtValor: TcxCurrencyEdit;
    Label3: TLabel;
    spnEstoque: TSpinEdit;
    Label4: TLabel;
    chkAtivo: TCheckBox;
    procedure btnSalvarClick(Sender: TObject);
  private
    { Private declarations }
    FidProduto: integer;
    FDataCadastro: string;
  public
    { Public declarations }
    property IdProduto: Integer read FidProduto write FidProduto;
    property DataCadastro: string read FDataCadastro write FDataCadastro;
  end;

var
  frmCadastrarProduto: TfrmCadastrarProduto;

implementation

{$R *.dfm}

uses UnitProdutos, UnitGlobal;

procedure TfrmCadastrarProduto.btnSalvarClick(Sender: TObject);
var
  LResponse: IResponse;
  LJson: TJSONObject;
  LAtivo: string;
begin
  if (Trim(edtNome.Text) = '') or (Trim(edtValor.Text) = '') then
  begin
    ShowMessage('Favor informe todos os campos!');
    ModalResult := mrNone;
    Exit;
  end;
  if (Tag = 1) and (FidProduto <= 0) then
  begin
    ShowMessage('Produto invalido para edicao. Feche e selecione novamente.');
    ModalResult := mrNone;
    Exit;
  end;
  if chkAtivo.Checked then
    LAtivo := 'S'
  else
    LAtivo := 'N';
  LJson := TJSONObject.Create;
  try
    LJson.AddPair('CategoriaID', Trim(comboCategoria.EditValue));
    LJson.AddPair('nome', Trim(edtNome.Text));
    LJson.AddPair('descricao', Trim(mmDescricao.Text));
    LJson.AddPair('preco', currtostr(edtValor.Value));
    LJson.AddPair('estoque', inttostr(spnEstoque.Value));
    LJson.AddPair('ativo', LAtivo);
    if Tag = 1 then
    begin
      // A API valida se o id do corpo e igual ao id da URL (senao devolve 400)
      LJson.AddPair('produtoID', FidProduto);
      // A API substitui o registro inteiro no PUT: sem esta data ela vira 0001-01-01
      if FDataCadastro <> '' then
        LJson.AddPair('dataCadastro', FDataCadastro);
      LResponse := TRequest.New
        .BaseURL(URL_API)
        .Resource('produtos/' + IntToStr(FidProduto))
        .Accept('application/json')
        .ContentType('application/json')
        .AddBody(LJson, False)
        .Put;
    end
    else
      LResponse := TRequest.New
        .BaseURL(URL_API)
        .Resource('produtos')
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
