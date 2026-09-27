object dmBase: TdmBase
  Height = 446
  Width = 809
  PixelsPerInch = 96
  object RESTClientCategorias: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:5236/api'
    Params = <>
    Left = 88
    Top = 24
  end
  object RESTRequestCategorias: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClientCategorias
    Params = <>
    Response = RESTResponseCategorias
    Left = 160
    Top = 48
  end
  object RESTResponseCategorias: TRESTResponse
    Left = 80
    Top = 80
  end
  object RESTResponseDataSetAdapterCategorias: TRESTResponseDataSetAdapter
    Dataset = TabCategorias
    FieldDefs = <>
    Response = RESTResponseCategorias
    Left = 80
    Top = 120
  end
  object TabCategorias: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 80
    Top = 168
  end
  object DataSourceCategorias: TDataSource
    DataSet = TabCategorias
    Left = 80
    Top = 232
  end
  object RESTClientCategoriasDelete: TRESTClient
    BaseURL = 'http://localhost:5236/api/Categorias/30'
    Params = <>
    Left = 328
    Top = 56
  end
  object RESTRequestCategoriasDelete: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClientCategoriasDelete
    Method = rmDELETE
    Params = <>
    Response = RESTResponseCategoriasDelete
    Left = 328
    Top = 112
  end
  object RESTResponseCategoriasDelete: TRESTResponse
    Left = 328
    Top = 176
  end
  object RESTClientCategoriasPost: TRESTClient
    BaseURL = 'http://localhost:5236/api/Categorias'
    Params = <>
    Left = 592
    Top = 80
  end
  object RESTRequestCategoriasPost: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClientCategoriasPost
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'body8588520D9196414B9F8B254BE18A0877'
        Value = '{'#13#10'  "nome": "ggggg",'#13#10'  "descricao": "gggg",'#13#10'  "ativo": "S"'#13#10'}'
        ContentTypeStr = 'application/json'
      end>
    Response = RESTResponseCategoriasPost
    Left = 592
    Top = 128
  end
  object RESTResponseCategoriasPost: TRESTResponse
    Left = 592
    Top = 176
  end
end
