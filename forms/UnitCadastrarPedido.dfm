object frmCadastrarPedido: TfrmCadastrarPedido
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Pedido'
  ClientHeight = 620
  ClientWidth = 860
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 860
    Height = 92
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblCliente: TLabel
      Left = 24
      Top = 14
      Width = 46
      Height = 20
      Caption = 'Cliente'
    end
    object lblSituacao: TLabel
      Left = 528
      Top = 14
      Width = 57
      Height = 20
      Caption = 'Situa'#231#227'o'
    end
    object cbCliente: TcxLookupComboBox
      Left = 24
      Top = 38
      Properties.KeyFieldNames = 'clienteID'
      Properties.ListColumns = <
        item
          FieldName = 'nome'
        end>
      Properties.ListSource = DataSourceClientes
      TabOrder = 0
      Width = 480
    end
    object cbSituacao: TcxComboBox
      Left = 528
      Top = 38
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        'PENDENTE'
        'PAGO'
        'FINALIZADO'
        'CANCELADO')
      TabOrder = 1
      Width = 260
    end
  end
  object pnlItens: TPanel
    Left = 0
    Top = 92
    Width = 860
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblProduto: TLabel
      Left = 24
      Top = 4
      Width = 53
      Height = 20
      Caption = 'Produto'
    end
    object lblQuantidade: TLabel
      Left = 464
      Top = 4
      Width = 25
      Height = 20
      Caption = 'Qtd'
    end
    object cbProduto: TcxLookupComboBox
      Left = 24
      Top = 28
      Properties.KeyFieldNames = 'produtoID'
      Properties.ListColumns = <
        item
          FieldName = 'nome'
        end>
      Properties.ListSource = DataSourceProdutos
      TabOrder = 0
      Width = 420
    end
    object spnQuantidade: TSpinEdit
      Left = 464
      Top = 28
      Width = 80
      Height = 30
      MaxValue = 9999
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
    object btnAdicionarItem: TButton
      Left = 570
      Top = 27
      Width = 120
      Height = 31
      Caption = 'Adicionar'
      TabOrder = 2
      OnClick = btnAdicionarItemClick
    end
    object btnRemoverItem: TButton
      Left = 700
      Top = 27
      Width = 120
      Height = 31
      Caption = 'Remover'
      TabOrder = 3
      OnClick = btnRemoverItemClick
    end
  end
  object cxGridItens: TcxGrid
    Left = 0
    Top = 168
    Width = 860
    Height = 384
    Align = alClient
    TabOrder = 2
    object cxGridItensDBTableViewItem: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = DataSourceItens
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object cxGridItensDBTableViewItemprodutoNome: TcxGridDBColumn
        Caption = 'Produto'
        DataBinding.FieldName = 'produtoNome'
        DataBinding.IsNullValueType = True
        Options.Editing = False
        Width = 300
      end
      object cxGridItensDBTableViewItemquantidade: TcxGridDBColumn
        Caption = 'Qtd'
        DataBinding.FieldName = 'quantidade'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxSpinEditProperties'
        Properties.MaxValue = 9999.000000000000000000
        Properties.MinValue = 1.000000000000000000
        Width = 90
      end
      object cxGridItensDBTableViewItemprecoUnitario: TcxGridDBColumn
        Caption = 'Pre'#231'o unit'#225'rio'
        DataBinding.FieldName = 'precoUnitario'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Options.Editing = False
        Width = 130
      end
      object cxGridItensDBTableViewItemsubTotal: TcxGridDBColumn
        Caption = 'Subtotal'
        DataBinding.FieldName = 'subTotal'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Options.Editing = False
        Width = 140
      end
    end
    object cxGridItensLevel1: TcxGridLevel
      GridView = cxGridItensDBTableViewItem
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 552
    Width = 860
    Height = 68
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object lblTotal: TLabel
      Left = 24
      Top = 20
      Width = 91
      Height = 25
      Caption = 'Total: 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnGravar: TButton
      Left = 606
      Top = 16
      Width = 110
      Height = 36
      Caption = 'Gravar'
      Default = True
      TabOrder = 0
      OnClick = btnGravarClick
    end
    object btnCancelar: TButton
      Left = 726
      Top = 16
      Width = 110
      Height = 36
      Cancel = True
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object TabItens: TFDMemTable
    BeforePost = TabItensBeforePost
    AfterPost = TabItensAfterPost
    AfterDelete = TabItensAfterDelete
    FieldDefs = <
      item
        Name = 'itemPedidoID'
        DataType = ftInteger
      end
      item
        Name = 'produtoID'
        DataType = ftInteger
      end
      item
        Name = 'produtoNome'
        DataType = ftWideString
        Size = 120
      end
      item
        Name = 'quantidade'
        DataType = ftInteger
      end
      item
        Name = 'precoUnitario'
        DataType = ftCurrency
      end
      item
        Name = 'subTotal'
        DataType = ftCurrency
      end
      item
        Name = 'qtdOriginal'
        DataType = ftInteger
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 40
    Top = 296
  end
  object DataSourceItens: TDataSource
    DataSet = TabItens
    Left = 152
    Top = 296
  end
  object RESTClientClientes: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:5236/api/clientes'
    Params = <>
    Left = 64
    Top = 376
  end
  object RESTRequestClientes: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClientClientes
    Params = <>
    Response = RESTResponseClientes
    Left = 176
    Top = 376
  end
  object RESTResponseClientes: TRESTResponse
    ContentType = 'application/json'
    Left = 288
    Top = 376
  end
  object RESTResponseDataSetAdapterClientes: TRESTResponseDataSetAdapter
    Active = True
    Dataset = TabClientes
    FieldDefs = <>
    Response = RESTResponseClientes
    Left = 400
    Top = 376
  end
  object TabClientes: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'clienteID'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'nome'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 512
    Top = 376
  end
  object DataSourceClientes: TDataSource
    DataSet = TabClientes
    Left = 624
    Top = 376
  end
  object RESTClientProdutos: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:5236/api/produtos'
    Params = <>
    Left = 64
    Top = 456
  end
  object RESTRequestProdutos: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClientProdutos
    Params = <>
    Response = RESTResponseProdutos
    Left = 176
    Top = 456
  end
  object RESTResponseProdutos: TRESTResponse
    ContentType = 'application/json'
    Left = 288
    Top = 456
  end
  object RESTResponseDataSetAdapterProdutos: TRESTResponseDataSetAdapter
    Active = True
    Dataset = TabProdutos
    FieldDefs = <>
    Response = RESTResponseProdutos
    Left = 400
    Top = 456
  end
  object TabProdutos: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'produtoID'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'nome'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'preco'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'estoque'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 512
    Top = 456
  end
  object DataSourceProdutos: TDataSource
    DataSet = TabProdutos
    Left = 624
    Top = 456
  end
end
