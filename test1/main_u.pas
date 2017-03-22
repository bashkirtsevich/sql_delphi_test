unit main_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, child_u;

type
  TfrmMain = class(TForm)
    mmWindows: TMainMenu;
    miWindow: TMenuItem;
    miAdd: TMenuItem;
    miCloseLast: TMenuItem;
    miClose: TMenuItem;
    miCloseAll: TMenuItem;
    actlstMain: TActionList;
    actAdd: TAction;
    actCloseLast: TAction;
    actClose: TAction;
    actCloseAll: TAction;
    procedure HandleWindowActions(Sender: TObject);
    procedure actlstMainUpdate(Action: TBasicAction; var Handled: Boolean);
  private
    FWindowNumCounter: Integer;
    // ������, ��� ����� ��������������� ��� ��������? � ��, ������ ��������, ����� �� ��������
    FWindowList: TList;

    procedure OnChildWindowClose(Sender: TfrmChild);
    function hasChilds: Boolean;
    procedure CloseAllChildsWindows;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

const
  ACT_ADD = 1;
  ACT_CLOSE_LAST = 2;
  ACT_CLOSE = 3;
  ACT_CLOSE_ALL = 4;

procedure TfrmMain.AfterConstruction;
begin
  inherited;

  FWindowNumCounter := 0;
  FWindowList := TList.Create;
end;

procedure TfrmMain.BeforeDestruction;
begin
  inherited;

  CloseAllChildsWindows;

  FWindowList.Free;
end;

procedure TfrmMain.CloseAllChildsWindows;
var
  i: Integer;
begin
  for i := Self.MDIChildCount - 1 downto 0 do
    Self.MDIChildren[i].Close;
end;

procedure TfrmMain.HandleWindowActions(Sender: TObject);
var
  action: TAction absolute Sender;
  wnd_num_str: string;
  wnd_num: Integer;
  i: Integer;
begin
  // ��� ������-��������� � ���������� �� �� ������ ���� ��� �������� ������
  case action.Tag of
    ACT_ADD:
      begin
        // acquire new num
        Inc(FWindowNumCounter);

        // ��� �� ������� ������������
        with TfrmChild(
          Self.FWindowList[
            Self.FWindowList.Add(
              TfrmChild.Create(Self, FWindowNumCounter)
            )
          ]
        ) do
          OnBeforeClose := OnChildWindowClose;
      end;

    ACT_CLOSE_LAST:
      begin
        if Self.hasChilds then
          TfrmChild(Self.FWindowList.Last).Close;
      end;

    ACT_CLOSE:
      begin
        wnd_num_str := EmptyStr;

        if Self.hasChilds and
          InputQuery('������� ����',
            '������� ����� ����, ������� ���������� �������', wnd_num_str) then
        begin
          if not TryStrToInt(wnd_num_str, wnd_num) then
            raise Exception.Create('������� �������� ��������')
          else
          for i := 0 to Self.FWindowList.Count - 1 do { �������� ������� ������, ��� � ���� ������ (������ 7) ��� �������� }
            with TfrmChild(Self.FWindowList[i]) do { ����-����, "with" -- ��� ��� }
              if WindowNum = wnd_num then
              begin
                Close;
                
                Exit;
              end;

          raise Exception.Create('������ ����� ��������������� ����');
        end;
      end;

    // ��������� ��� �������� ����
    ACT_CLOSE_ALL:
      CloseAllChildsWindows;
  end;
end;

procedure TfrmMain.OnChildWindowClose(Sender: TfrmChild);
begin
  // ��� �� ������� ������������
  Self.FWindowList.Remove(Sender);
end;

procedure TfrmMain.actlstMainUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actCloseLast.Enabled := Self.FWindowList.Count > 0;
  actClose.Enabled := actCloseLast.Enabled;
  actCloseAll.Enabled := actCloseLast.Enabled;
end;

function TfrmMain.hasChilds: Boolean;
begin
  Result := Self.FWindowList.Count > 0;
end;

end.
