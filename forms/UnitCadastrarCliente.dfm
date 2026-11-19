object frmCadastrarCliente: TfrmCadastrarCliente
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cliente'
  ClientHeight = 370
  ClientWidth = 506
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
    Top = 333
    Width = 506
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 338
    DesignSize = (
      506
      37)
    object btnSalvar: TButton
      Left = 338
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 419
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 486
    Height = 289
    Caption = 'Dados do cliente'
    TabOrder = 1
    object edtNome: TLabeledEdit
      Left = 24
      Top = 64
      Width = 425
      Height = 29
      EditLabel.Width = 112
      EditLabel.Height = 21
      EditLabel.Caption = 'Nome completo'
      MaxLength = 50
      TabOrder = 0
      Text = ''
    end
    object edtEmail: TLabeledEdit
      Left = 24
      Top = 136
      Width = 425
      Height = 29
      EditLabel.Width = 44
      EditLabel.Height = 21
      EditLabel.Caption = 'E-mail'
      MaxLength = 50
      TabOrder = 1
      Text = ''
    end
    object edtFone: TLabeledEdit
      Left = 24
      Top = 208
      Width = 215
      Height = 29
      EditLabel.Width = 57
      EditLabel.Height = 21
      EditLabel.Caption = 'Telefone'
      EditMask = '!\(99\)00000-0000;0;_'
      MaxLength = 14
      TabOrder = 2
      Text = ''
    end
  end
  object chkAtivo: TCheckBox
    Left = 384
    Top = 32
    Width = 73
    Height = 17
    Caption = 'Ativo'
    TabOrder = 2
  end
end
