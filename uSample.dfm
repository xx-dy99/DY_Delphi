object frmSample: TfrmSample
  Left = 3735
  Top = 745
  Width = 312
  Height = 303
  Caption = '예제 폼'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TLabel
    Left = 18
    Top = 96
    Width = 100
    Height = 13
    Caption = '첫번째 에디트 박스 :'
  end
  object lblFirst: TLabel
    Left = 209
    Top = 96
    Width = 6
    Height = 13
    Caption = '?'
  end
  object TLabel
    Left = 18
    Top = 126
    Width = 100
    Height = 13
    Caption = '두번재 에디트 박스 :'
  end
  object lblSecond: TLabel
    Left = 209
    Top = 126
    Width = 6
    Height = 13
    Caption = '?'
  end
  object edtFirst: TEdit
    Left = 18
    Top = 21
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtSecond: TEdit
    Left = 154
    Top = 21
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object btnCheck: TButton
    Left = 50
    Top = 195
    Width = 191
    Height = 22
    Caption = '확인'
    TabOrder = 2
    OnClick = btnCheckClick
  end
end
