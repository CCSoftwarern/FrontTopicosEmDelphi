unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Mask, Vcl.ExtCtrls,  REST.Client, System.JSON, REST.Types;

type
  TFormMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    edtUrlApi: TLabeledEdit;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    btnCarregar: TButton;
    btnIncluir: TButton;
    Bevel1: TBevel;
    lblMenu: TLabel;
    btnExcluir: TButton;
    ShapeStatus: TShape;
    lblStatus: TLabel;
    edtNome: TLabeledEdit;
    edtDescricao: TLabeledEdit;
    procedure btnCarregarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
  private
    { Private declarations }
    procedure ExecutarConsulta(AClient: TRESTClient;ARequest: TRESTRequest;AResponse: TRESTResponse;const AEndpoint: string);
     procedure ExecutarPost(
  AClient: TRESTClient;
  ARequest: TRESTRequest;
  AResponse: TRESTResponse;
  const AEndpoint: string;
  Dados: TJSONObject
);
    procedure MudarCorStatus(CorLinha, CorInterno: Tcolor; Shape:TShape; Mensagem:string; ALabel: Tlabel);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses UnitDmBase;

procedure TFormMain.btnCarregarClick(Sender: TObject);
begin
ExecutarConsulta(
  dmBase.RESTClientCategorias,
  dmBase.RESTRequestCategorias,
  dmBase.RESTResponseCategorias,
  'Categorias'
);

end;

procedure TFormMain.btnExcluirClick(Sender: TObject);
begin
ExecutarConsulta(
  dmBase.RESTClientCategoriasDelete,
  dmBase.RESTRequestCategoriasDelete,
  dmBase.RESTResponseCategoriasDelete,
  'Categorias/'+dmBase.TabCategorias.FieldByName('categoriaID').Text
);

end;


procedure TFormMain.btnIncluirClick(Sender: TObject);

var
  Json: TJSONObject;
begin
if (edtNome.Text = '') or (edtDescricao.Text = '') then
begin
      MudarCorStatus($000606FF,$00C4C4FF,ShapeStatus,'Favor preencher os campos Nome e Descrição', lblStatus);
      abort;

end;

  Json := TJSONObject.Create;
  try
    Json.AddPair('nome', edtNome.Text);
    Json.AddPair('descricao', edtDescricao.Text);
    Json.AddPair('ativo', 'S');
    ExecutarPost(
      dmBase.RESTClientCategoriasPost,
      dmBase.RESTRequestCategoriasPost,
      dmBase.RESTResponseCategoriasPost,
      edtUrlApi.Text + 'Categorias',
      Json
    );
  finally begin
    Json.Free;
    btnCarregar.Click;
  end;
  end;
end;

// criei a procedure pra diminuir a repetição de código
procedure TFormMain.ExecutarConsulta(AClient: TRESTClient;
  ARequest: TRESTRequest; AResponse: TRESTResponse; const AEndpoint: string);
begin
  AClient.BaseURL := edtUrlApi.Text+ AEndpoint;
  ARequest.Client := AClient;
  ARequest.Response := AResponse;
  ARequest.ExecuteAsync(
    procedure
    begin
      if (AResponse.StatusCode = 200) or (AResponse.StatusCode = 204) or (AResponse.StatusCode = 201) then begin
      MudarCorStatus($0033CC00,$0080FF00,ShapeStatus,AResponse.StatusText, lblStatus) ;
      end

      else
      MudarCorStatus($000606FF,$00C4C4FF,ShapeStatus,'Erro: ' +
          AResponse.StatusCode.ToString + ' - ' +
          AResponse.StatusText, lblStatus)
    end
  );

end;

procedure TFormMain.ExecutarPost(AClient: TRESTClient; ARequest: TRESTRequest;
  AResponse: TRESTResponse; const AEndpoint: string; Dados: TJSONObject);
begin
  AClient.BaseURL := AEndpoint;
  ARequest.Client := AClient;
  ARequest.Response := AResponse;
  ARequest.Method := rmPOST;
  ARequest.Params.Clear;
  ARequest.AddBody(Dados.ToJSON, ctAPPLICATION_JSON);
  ARequest.ExecuteAsync(
    procedure
    begin
      if (AResponse.StatusCode = 200) or (AResponse.StatusCode = 204) or (AResponse.StatusCode = 201) then begin
      MudarCorStatus($0033CC00,$0080FF00,ShapeStatus,AResponse.StatusText, lblStatus) ;
      end

      else
      MudarCorStatus($000606FF,$00C4C4FF,ShapeStatus,'Erro: ' +
          AResponse.StatusCode.ToString + ' - ' +
          AResponse.StatusText, lblStatus)
    end
  );

end;

procedure TFormMain.MudarCorStatus(CorLinha, CorInterno: Tcolor;
  Shape: TShape; Mensagem:string; ALabel: Tlabel);
begin
  Shape.Repaint;
  Shape.Pen.Color:= CorLinha;
  Shape.Brush.Color:= CorInterno;
  ALabel.Caption:= Mensagem;

end;

end.
