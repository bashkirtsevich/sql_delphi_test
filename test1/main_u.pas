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
    // кошмар, как можно программировать без шаблонов? и да, привет поинтеры, давно не виделись
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
  // без лямбда-выражений и итераторов на их основе этот код выглядит стрёмно
  case action.Tag of
    ACT_ADD:
      begin
        // acquire new num
        Inc(FWindowNumCounter);

        // тут бы словарь использовать
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
          InputQuery('Закрыть окно',
            'Укажите номер окна, которое необходимо закрыть', wnd_num_str) then
        begin
          if not TryStrToInt(wnd_num_str, wnd_num) then
            raise Exception.Create('Укажите числовое значение')
          else
          for i := 0 to Self.FWindowList.Count - 1 do { линейный перебор списка, ибо в этой дельфи (версия 7) нет словарей }
            with TfrmChild(Self.FWindowList[i]) do { знаю-знаю, "with" -- это зло }
              if WindowNum = wnd_num then
              begin
                Close;
                
                Exit;
              end;

          raise Exception.Create('Указан номер несуществующего окна');
        end;
      end;

    // закрываем все дочерние окна
    ACT_CLOSE_ALL:
      CloseAllChildsWindows;
  end;
end;

procedure TfrmMain.OnChildWindowClose(Sender: TfrmChild);
begin
  // тут бы словарь использовать
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
