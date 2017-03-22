unit child_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmChild = class;
  
  TBeforeCloseEvent = procedure (Sender: TfrmChild) of object;

  TfrmChild = class(TForm)
    lblTitle: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FWindowNum: Integer;
    FOnClose: TBeforeCloseEvent;
  public
    property WindowNum: Integer read FWindowNum;
    property OnBeforeClose: TBeforeCloseEvent read FOnClose write FOnClose;
    
    constructor Create(AOwner: TComponent; AWindowNum: Integer); reintroduce;
  end;

implementation

{$R *.dfm}

{ TfrmChild }

constructor TfrmChild.Create(AOwner: TComponent; AWindowNum: Integer);
begin
  inherited Create(AOwner);

  FWindowNum := AWindowNum;

  Self.lblTitle.Caption := IntToStr(AWindowNum);
end;

procedure TfrmChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FOnClose) then
    FOnClose(Self);

  Action := caFree;
end;

end.
