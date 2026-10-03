object FrmLogin: TFrmLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Login'
  ClientHeight = 374
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 28
  object Bevel1: TBevel
    Left = 16
    Top = 16
    Width = 417
    Height = 249
  end
  object Button2: TButton
    Left = 161
    Top = 288
    Width = 144
    Height = 41
    Caption = 'Entrar'
    TabOrder = 0
    OnClick = Button2Click
  end
  object edtEmail: TLabeledEdit
    Left = 48
    Top = 80
    Width = 353
    Height = 36
    EditLabel.Width = 59
    EditLabel.Height = 28
    EditLabel.Caption = 'E-mail:'
    TabOrder = 1
    Text = 'teste@exemplo.com'
  end
  object edtSenha: TLabeledEdit
    Left = 48
    Top = 168
    Width = 353
    Height = 30
    EditLabel.Width = 57
    EditLabel.Height = 28
    EditLabel.Caption = 'Senha:'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Wingdings'
    Font.Style = []
    ParentFont = False
    PasswordChar = 'l'
    TabOrder = 2
    Text = 'senha123'
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
