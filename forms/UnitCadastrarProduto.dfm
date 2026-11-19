object frmCadastrarProduto: TfrmCadastrarProduto
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro Produto'
  ClientHeight = 532
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 21
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 537
    Height = 449
    Caption = 'Dados do produto'
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 45
      Width = 70
      Height = 21
      Caption = 'Categoria:'
    end
    object Label2: TLabel
      Left = 32
      Top = 184
      Width = 70
      Height = 21
      Caption = 'Descri'#231#227'o:'
    end
    object Label3: TLabel
      Left = 32
      Top = 317
      Width = 39
      Height = 21
      Caption = 'Valor:'
    end
    object Label4: TLabel
      Left = 208
      Top = 317
      Width = 58
      Height = 21
      Caption = 'Estoque:'
    end
    object comboCategoria: TcxLookupComboBox
      Left = 32
      Top = 72
      Properties.KeyFieldNames = 'categoriaID'
      Properties.ListColumns = <
        item
          FieldName = 'nome'
        end>
      Properties.ListSource = frmProdutos.DataSourceCategorias
      TabOrder = 0
      Width = 473
    end
    object edtNome: TLabeledEdit
      Left = 32
      Top = 136
      Width = 473
      Height = 29
      EditLabel.Width = 46
      EditLabel.Height = 21
      EditLabel.Caption = 'Nome:'
      TabOrder = 1
      Text = ''
    end
    object mmDescricao: TMemo
      Left = 32
      Top = 211
      Width = 473
      Height = 89
      TabOrder = 2
    end
    object edtValor: TcxCurrencyEdit
      Left = 32
      Top = 344
      TabOrder = 3
      Width = 161
    end
    object spnEstoque: TSpinEdit
      Left = 208
      Top = 344
      Width = 97
      Height = 31
      MaxValue = 100000
      MinValue = 1
      TabOrder = 4
      Value = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 495
    Width = 558
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      558
      37)
    object btnSalvar: TButton
      Left = 396
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
      Left = 477
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
  object chkAtivo: TCheckBox
    Left = 440
    Top = 40
    Width = 73
    Height = 17
    Caption = 'Ativo'
    TabOrder = 2
  end
end
