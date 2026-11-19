object frmCadastrarCategoria: TfrmCadastrarCategoria
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastrar Categoria'
  ClientHeight = 322
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 21
  object Panel1: TPanel
    Left = 0
    Top = 285
    Width = 434
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 272
    DesignSize = (
      434
      37)
    object Button1: TButton
      Left = 266
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Gravar'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 353
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 418
    Height = 241
    Caption = 'Categoria'
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 99
      Width = 70
      Height = 21
      Caption = 'Descri'#231#227'o:'
    end
    object edtNome: TLabeledEdit
      Left = 16
      Top = 64
      Width = 377
      Height = 29
      EditLabel.Width = 46
      EditLabel.Height = 21
      EditLabel.Caption = 'Nome:'
      TabOrder = 0
      Text = ''
    end
    object mmDescricao: TMemo
      Left = 16
      Top = 126
      Width = 377
      Height = 89
      MaxLength = 50
      TabOrder = 1
    end
    object chkAtivo: TCheckBox
      Left = 320
      Top = 24
      Width = 73
      Height = 17
      Caption = 'Ativo'
      TabOrder = 2
    end
  end
end
