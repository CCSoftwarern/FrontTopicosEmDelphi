unit uApiRepository;

interface

uses
  System.SysUtils, System.JSON, System.Classes,
  REST.Json, RESTRequest4D, uApiClient;

type
  TApiRepository<T: class, constructor> = class
  private
    FApi: TApiClient;
    FRecurso: string;
    function ListaParaObjetos(const AResposta: TApiResposta): TArray<T>;
  public
    constructor Create(AApi: TApiClient; const ARecurso: string);

    function Listar(AConfigurar: TProc<IRequest> = nil): TArray<T>;
    function Obter(AId: Integer): T;
    function Inserir(const AObjeto: T): Boolean;
    function Atualizar(AId: Integer; const AObjeto: T): Boolean;
    function Excluir(AId: Integer): Boolean;
  end;

implementation

constructor TApiRepository<T>.Create(AApi: TApiClient; const ARecurso: string);
begin
  inherited Create;
  FApi := AApi;
  FRecurso := ARecurso;
end;

function TApiRepository<T>.ListaParaObjetos(const AResposta: TApiResposta): TArray<T>;
var
  LJSON: TJSONValue;
  LArray: TJSONArray;
  I: Integer;
begin
  if not AResposta.Sucesso then
    raise EApiException.Create(AResposta.MensagemErro, AResposta.StatusCode);

  LJSON := AResposta.JSON;
  try
    if not (LJSON is TJSONArray) then
      raise EApiException.Create('A API nao retornou uma lista.');
    LArray := TJSONArray(LJSON);
    SetLength(Result, LArray.Count);
    for I := 0 to LArray.Count - 1 do
      Result[I] := TJson.JsonToObject<T>(LArray.Items[I].ToJSON);
  finally
    LJSON.Free;
  end;
end;

function TApiRepository<T>.Listar(AConfigurar: TProc<IRequest>): TArray<T>;
var
  LRequest: IRequest;
begin
  LRequest := FApi.Novo(FRecurso);
  if Assigned(AConfigurar) then
    AConfigurar(LRequest);
  Result := ListaParaObjetos(FApi.Processar(LRequest.Get));
end;

function TApiRepository<T>.Obter(AId: Integer): T;
var
  LResposta: TApiResposta;
  LJSON: TJSONValue;
begin
  LResposta := FApi.Get(FRecurso + '/' + IntToStr(AId));
  if not LResposta.Sucesso then
    raise EApiException.Create(LResposta.MensagemErro, LResposta.StatusCode);

  LJSON := LResposta.JSON;
  try
    Result := TJson.JsonToObject<T>(LJSON.ToJSON);
  finally
    LJSON.Free;
  end;
end;

function TApiRepository<T>.Inserir(const AObjeto: T): Boolean;
var
  LResposta: TApiResposta;
begin
  LResposta := FApi.Post(FRecurso, TJson.ObjectToJsonString(AObjeto));
  Result := LResposta.Sucesso;
  if not Result then
    raise EApiException.Create(LResposta.MensagemErro, LResposta.StatusCode);
end;

function TApiRepository<T>.Atualizar(AId: Integer; const AObjeto: T): Boolean;
var
  LResposta: TApiResposta;
begin
  LResposta := FApi.Put(FRecurso + '/' + IntToStr(AId),
    TJson.ObjectToJsonString(AObjeto));
  Result := LResposta.Sucesso;
  if not Result then
    raise EApiException.Create(LResposta.MensagemErro, LResposta.StatusCode);
end;

function TApiRepository<T>.Excluir(AId: Integer): Boolean;
var
  LResposta: TApiResposta;
begin
  LResposta := FApi.Delete(FRecurso + '/' + IntToStr(AId));
  Result := LResposta.Sucesso;
  if not Result then
    raise EApiException.Create(LResposta.MensagemErro, LResposta.StatusCode);
end;

end.
