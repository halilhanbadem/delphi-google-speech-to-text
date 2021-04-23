object fMain: TfMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'fMain'
  ClientHeight = 146
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 104
    Height = 13
    Caption = 'Load Private Key File:'
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 105
    Height = 13
    Caption = 'Load Voice File (wav):'
  end
  object btnGetText: TButton
    Left = 8
    Top = 98
    Width = 161
    Height = 33
    Caption = 'Get Text'
    TabOrder = 0
    OnClick = btnGetTextClick
  end
  object edtPrivateKey: TEdit
    Left = 8
    Top = 29
    Width = 385
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object edtVoiceFile: TEdit
    Left = 8
    Top = 71
    Width = 385
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object btnPrivateKey: TButton
    Left = 399
    Top = 27
    Width = 42
    Height = 25
    Caption = '...'
    TabOrder = 3
    OnClick = btnPrivateKeyClick
  end
  object btnVoiceFile: TButton
    Left = 399
    Top = 69
    Width = 42
    Height = 25
    Caption = '...'
    TabOrder = 4
    OnClick = btnVoiceFileClick
  end
  object Voice: TOpenDialog
    Filter = 'WAV Files|*.wav'
    Left = 216
    Top = 104
  end
  object PrivateKey: TOpenDialog
    Filter = 'JSON File|*.json'
    Left = 288
    Top = 104
  end
  object hbGoogle1: ThbGoogle
    SpeechLanguage = 'en-EN'
    SpeechEncoding = 'LINEAR16'
    Left = 364
    Top = 104
  end
end
