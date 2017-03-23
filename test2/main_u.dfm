object frmMain: TfrmMain
  Left = 192
  Top = 114
  Width = 1305
  Height = 650
  Caption = 'frmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCenter: TPanel
    Left = 0
    Top = 0
    Width = 1297
    Height = 528
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlButtons: TPanel
      Left = 0
      Top = 0
      Width = 1297
      Height = 41
      Align = alTop
      TabOrder = 0
      object btnOpen: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = #1054#1090#1082#1088#1099#1090#1100
        TabOrder = 0
        OnClick = btnOpenClick
      end
      object btnQuit: TButton
        Left = 88
        Top = 8
        Width = 75
        Height = 25
        Caption = #1042#1099#1093#1086#1076
        TabOrder = 1
        OnClick = btnQuitClick
      end
    end
    object pnlCenterContent: TPanel
      Left = 0
      Top = 41
      Width = 1297
      Height = 487
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object splCenter: TSplitter
        Left = 632
        Top = 0
        Height = 487
      end
      object pnlCenterLeft: TPanel
        Left = 0
        Top = 0
        Width = 632
        Height = 487
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object lblLastName: TLabel
          Left = 0
          Top = 0
          Width = 632
          Height = 13
          Align = alTop
          AutoSize = False
          Caption = #1060#1072#1084#1080#1083#1080#1080
        end
        object lstLastNames: TListBox
          Left = 0
          Top = 13
          Width = 632
          Height = 474
          Align = alClient
          ItemHeight = 13
          TabOrder = 0
        end
      end
      object pnlCenterRight: TPanel
        Left = 635
        Top = 0
        Width = 662
        Height = 487
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object lblSums: TLabel
          Left = 0
          Top = 0
          Width = 662
          Height = 13
          Align = alTop
          AutoSize = False
          Caption = #1057#1091#1084#1084#1099
        end
        object lstSums: TListBox
          Left = 0
          Top = 13
          Width = 662
          Height = 474
          Align = alClient
          ItemHeight = 13
          TabOrder = 0
        end
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 528
    Width = 1297
    Height = 88
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object rgDuplicates: TRadioGroup
      Left = 0
      Top = 0
      Width = 353
      Height = 88
      Align = alLeft
      Caption = #1044#1091#1073#1083#1080#1082#1072#1090#1099
      Columns = 2
      Enabled = False
      Items.Strings = (
        #1057' '#1076#1091#1073#1083#1080#1082#1072#1090#1072#1084#1080
        #1041#1077#1079' '#1076#1091#1073#1083#1080#1082#1072#1090#1086#1074)
      TabOrder = 0
    end
    object pnlBottomRight: TPanel
      Left = 353
      Top = 0
      Width = 944
      Height = 88
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        944
        88)
      object lblTotal: TLabel
        Left = 719
        Top = 36
        Width = 80
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = #1048#1090#1086#1075#1086#1074#1072#1103' '#1089#1091#1084#1084#1072
      end
      object edtTotal: TEdit
        Left = 807
        Top = 32
        Width = 121
        Height = 21
        Anchors = [akRight, akBottom]
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object dlgOpenExcel: TOpenDialog
    Filter = 'Excel files|*.xls'
    Left = 8
    Top = 48
  end
end
