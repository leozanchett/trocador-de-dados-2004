object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Usuario e senha acesso banco de dados'
  ClientHeight = 138
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 241
    Height = 73
    TabOrder = 0
    object lblUsuario: TLabel
      Left = 14
      Top = 14
      Width = 36
      Height = 13
      Caption = 'Usu'#225'rio'
    end
    object lblSenha: TLabel
      Left = 14
      Top = 47
      Width = 30
      Height = 13
      Caption = 'Senha'
    end
    object edtUsuario: TEdit
      Left = 56
      Top = 11
      Width = 177
      Height = 21
      TabOrder = 0
    end
    object edtSenha: TEdit
      Left = 56
      Top = 41
      Width = 177
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
  end
  object btnConfirmar: TBitBtn
    Left = 72
    Top = 98
    Width = 129
    Height = 25
    Caption = 'Confirmar'
    TabOrder = 1
    OnClick = btnConfirmarClick
  end
end
