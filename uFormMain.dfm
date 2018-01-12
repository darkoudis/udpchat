object ChatForm: TChatForm
  Left = 340
  Top = 184
  Width = 696
  Height = 480
  Caption = 'udp chat'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    680
    442)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 673
    Height = 53
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Server me'
    TabOrder = 0
    object LabelServerPort: TLabel
      Left = 56
      Top = 20
      Width = 19
      Height = 13
      Caption = 'Port'
    end
    object LabelServerState: TLabel
      Left = 300
      Top = 20
      Width = 82
      Height = 13
      Caption = 'LabelServerState'
    end
    object EditServerPort: TEdit
      Left = 80
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '1777'
    end
    object BtnStartServer: TButton
      Left = 212
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Start Server'
      TabOrder = 1
      OnClick = BtnStartServerClick
    end
  end
  object MemoMessages: TMemo
    Left = 8
    Top = 68
    Width = 673
    Height = 289
    TabStop = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 364
    Width = 673
    Height = 85
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'server far'
    TabOrder = 2
    DesignSize = (
      673
      85)
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 21
      Height = 13
      Caption = 'Text'
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 29
      Height = 13
      Caption = 'server'
    end
    object Label3: TLabel
      Left = 180
      Top = 52
      Width = 19
      Height = 13
      Caption = 'Port'
    end
    object LabelSendPort: TLabel
      Left = 416
      Top = 56
      Width = 3
      Height = 13
    end
    object EditMessage: TEdit
      Left = 44
      Top = 16
      Width = 621
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = '1234'
    end
    object EditSendAddr: TEdit
      Left = 44
      Top = 52
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '192.168.0.98'
    end
    object BtnSend: TButton
      Left = 308
      Top = 52
      Width = 75
      Height = 25
      Caption = 'send'
      TabOrder = 3
      OnClick = BtnSendClick
    end
    object EditSendPort: TEdit
      Left = 212
      Top = 52
      Width = 81
      Height = 21
      TabOrder = 2
      Text = '1777'
    end
  end
end
