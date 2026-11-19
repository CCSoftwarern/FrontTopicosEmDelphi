object dmBase: TdmBase
  Height = 446
  Width = 809
  PixelsPerInch = 96
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
end
