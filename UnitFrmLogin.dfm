object FrmLogin: TFrmLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'LojaDB - Acesso'
  ClientHeight = 420
  ClientWidth = 760
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 20
  object pnlMarca: TPanel
    Left = 0
    Top = 0
    Width = 300
    Height = 420
    Align = alLeft
    BevelOuter = bvNone
    Color = 3877150
    ParentBackground = False
    TabOrder = 0
    object lblMarca: TLabel
      Left = 32
      Top = 124
      Width = 160
      Height = 65
      Caption = 'LojaDB'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -48
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblSlogan: TLabel
      Left = 34
      Top = 192
      Width = 186
      Height = 20
      Caption = 'Gest'#227'o de vendas e estoque'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12100500
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object lblAcessoRestrito: TLabel
      Left = 34
      Top = 372
      Width = 87
      Height = 17
      Caption = 'Acesso restrito'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12100500
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object pnlAcento: TPanel
      Left = 296
      Top = 0
      Width = 4
      Height = 420
      Align = alRight
      BevelOuter = bvNone
      Color = 15426341
      ParentBackground = False
      TabOrder = 0
    end
  end
  object pnlLogin: TPanel
    Left = 300
    Top = 0
    Width = 460
    Height = 420
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object lblBoasVindas: TLabel
      Left = 48
      Top = 52
      Width = 165
      Height = 45
      Caption = 'Bem-vindo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitulo: TLabel
      Left = 50
      Top = 100
      Width = 288
      Height = 20
      Caption = 'Acesse com suas credenciais para continuar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9139300
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblEmail: TLabel
      Left = 50
      Top = 152
      Width = 44
      Height = 17
      Caption = 'E-MAIL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9139300
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSenha: TLabel
      Left = 50
      Top = 222
      Width = 43
      Height = 17
      Caption = 'SENHA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9139300
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblErro: TLabel
      Left = 48
      Top = 378
      Width = 364
      Height = 22
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 1842361
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object edtEmail: TEdit
      Left = 48
      Top = 174
      Width = 364
      Height = 29
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'teste@exemplo.com'
      TextHint = 'seu@email.com'
    end
    object edtSenha: TEdit
      Left = 48
      Top = 244
      Width = 364
      Height = 29
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
      Text = 'senha123'
    end
    object chkMostrarSenha: TCheckBox
      Left = 48
      Top = 288
      Width = 145
      Height = 21
      Caption = 'Mostrar senha'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9139300
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = chkMostrarSenhaClick
    end
    object btnEntrar: TButton
      Left = 48
      Top = 330
      Width = 364
      Height = 42
      Cursor = crHandPoint
      Caption = 'Entrar'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnEntrarClick
    end
  end
  object RESTClientLogin: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:5236/api/Auth/login'
    ContentType = 'application/json'
    Params = <>
    Left = 104
    Top = 208
  end
  object RESTRequestLogin: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClientLogin
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'body5C366DDCEC9B441382CD828445FFC5AE'
        Value = '{'#13#10'  "email": "teste@exemplo.com",'#13#10'  "password": "senha123"'#13#10'}'
        ContentTypeStr = 'application/json'
      end>
    Response = RESTResponseLogin
    Left = 216
    Top = 208
  end
  object RESTResponseLogin: TRESTResponse
    ContentType = 'application/json'
    Left = 336
    Top = 208
  end
end
