object frmCadastrarUsuario: TfrmCadastrarUsuario
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Usu'#225'rio'
  ClientHeight = 400
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 21
  object Panel1: TPanel
    Left = 0
    Top = 355
    Width = 506
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      506
      45)
    object btnSalvar: TButton
      Left = 325
      Top = 8
      Width = 82
      Height = 30
      Anchors = [akTop, akRight]
      Caption = 'Salvar'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 413
      Top = 8
      Width = 82
      Height = 30
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 482
    Height = 333
    Caption = 'Dados do usu'#225'rio'
    TabOrder = 1
    object edtNome: TLabeledEdit
      Left = 24
      Top = 56
      Width = 425
      Height = 29
      EditLabel.Width = 120
      EditLabel.Height = 21
      EditLabel.Caption = 'Nome completo'
      MaxLength = 100
      TabOrder = 0
      Text = ''
    end
    object edtEmail: TLabeledEdit
      Left = 24
      Top = 126
      Width = 425
      Height = 29
      EditLabel.Width = 44
      EditLabel.Height = 21
      EditLabel.Caption = 'E-mail'
      MaxLength = 50
      TabOrder = 1
      Text = ''
    end
    object edtSenha: TLabeledEdit
      Left = 24
      Top = 196
      Width = 250
      Height = 29
      EditLabel.Width = 41
      EditLabel.Height = 21
      EditLabel.Caption = 'Senha'
      MaxLength = 30
      PasswordChar = '*'
      TabOrder = 2
      Text = ''
    end
    object lblTipo: TLabel
      Left = 300
      Top = 174
      Width = 106
      Height = 21
      Caption = 'Tipo de acesso'
    end
    object cbTipo: TComboBox
      Left = 300
      Top = 196
      Width = 149
      Height = 29
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'Padr'#227'o'
      Items.Strings = (
        'Padr'#227'o'
        'Administrador')
    end
    object chkAtivo: TCheckBox
      Left = 24
      Top = 252
      Width = 160
      Height = 21
      Caption = 'Usu'#225'rio ativo'
      TabOrder = 4
    end
    object lblAviso: TLabel
      Left = 24
      Top = 289
      Width = 430
      Height = 36
      AutoSize = False
      Caption = 
        'O tipo de acesso e a senha n'#227'o podem ser alterados nesta tela.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
    end
  end
end
