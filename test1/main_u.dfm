object frmMain: TfrmMain
  Left = 190
  Top = 110
  Width = 1305
  Height = 650
  Caption = 'frmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = mmWindows
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object mmWindows: TMainMenu
    Left = 8
    Top = 8
    object miWindow: TMenuItem
      Caption = #1054#1082#1085#1086
      object miAdd: TMenuItem
        Action = actAdd
      end
      object miCloseLast: TMenuItem
        Action = actCloseLast
      end
      object miClose: TMenuItem
        Action = actClose
      end
      object miCloseAll: TMenuItem
        Action = actCloseAll
      end
    end
  end
  object actlstMain: TActionList
    OnUpdate = actlstMainUpdate
    Left = 56
    Top = 8
    object actAdd: TAction
      Tag = 1
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = HandleWindowActions
    end
    object actCloseLast: TAction
      Tag = 2
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1077#1077
      OnExecute = HandleWindowActions
    end
    object actClose: TAction
      Tag = 3
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnExecute = HandleWindowActions
    end
    object actCloseAll: TAction
      Tag = 4
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1089#1077
      OnExecute = HandleWindowActions
    end
  end
end
