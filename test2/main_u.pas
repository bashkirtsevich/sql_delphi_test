unit main_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComObj, ActiveX;

type
  TfrmMain = class(TForm)
    pnlCenter: TPanel;
    pnlBottom: TPanel;
    rgDuplicates: TRadioGroup;
    pnlBottomRight: TPanel;
    pnlButtons: TPanel;
    btnOpen: TButton;
    btnQuit: TButton;
    edtTotal: TEdit;
    lblTotal: TLabel;
    dlgOpenExcel: TOpenDialog;
    pnlCenterContent: TPanel;
    pnlCenterLeft: TPanel;
    splCenter: TSplitter;
    pnlCenterRight: TPanel;
    lblLastName: TLabel;
    lblSums: TLabel;
    lstLastNames: TListBox;
    lstSums: TListBox;
    procedure btnQuitClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnQuitClick(Sender: TObject);
begin
  Close;
end;

{
procedure sh1(SheetIndex:integer);
Var
  Xlapp1, Sheet:Variant ;
  MaxRow, MaxCol,X, Y:integer ;
  str:string;
  arrData:Variant;
begin
  Str:=trim(form1.OpenDialog1.FileName);

  XLApp1 := createoleobject('excel.application');
  XLApp1.Workbooks.open(Str) ;

  Sheet := XLApp1.WorkSheets[SheetIndex] ;

  MaxRow := Sheet.Usedrange.EntireRow.count ;
  MaxCol := sheet.Usedrange.EntireColumn.count;

  //read the used range to a variant array
  arrData:= Sheet.UsedRange.Value;

  form1.stringgrid1.RowCount:=maxRow+1;
  form1.StringGrid1.ColCount:=maxCol+1;

  for x:=1 to maxCol do
    for y:=1 to maxRow do
      //copy data to grid
      form1.stringgrid1.Cells[x,y]:=arrData[y, x]; // do note that the indices are reversed (y, x)

  XLApp1.Workbooks.close;
end;
}

procedure TfrmMain.btnOpenClick(Sender: TObject);

  function AddLastName(const ALastName: string): Boolean;
  begin
    Self.lstLastNames.Items.BeginUpdate;
    try
      Result := Self.lstLastNames.Items.IndexOf(ALastName) = -1;

      if Result then
        Self.lstLastNames.Items.Add(ALastName);
    finally
      Self.lstLastNames.Items.EndUpdate;
    end;
  end;

var
  Xlapp1, Sheet: Variant;
  MaxRow, MaxCol, i: integer;
  val, total: Extended;
  arrData: Variant;
begin
  if Self.dlgOpenExcel.Execute and FileExists(Self.dlgOpenExcel.FileName) then
  begin
    Self.lstLastNames.Clear;
    Self.lstSums.Clear;
    Self.rgDuplicates.ItemIndex := 1;

    XLApp1 := CreateOLEObject('excel.application');
    try
      XLApp1.Workbooks.open(Self.dlgOpenExcel.FileName) ;

      Sheet := XLApp1.WorkSheets[1] ;

      MaxRow := Sheet.Usedrange.EntireRow.count;
      MaxCol := sheet.Usedrange.EntireColumn.count;

      if MaxCol < 2 then
        raise Exception.Create(
          'Ожидалось, что в таблице будет как минимум две колонки с данными на первом листе'
        );

      arrData := Sheet.UsedRange.Value;

      total := 0.0;

      for i := 1 to MaxRow do
      begin
        if not AddLastName(arrData[i, 1]) and (Self.rgDuplicates.ItemIndex = 1) then
          Self.rgDuplicates.ItemIndex := 0;

        try
          val := arrData[i, 2];

          Self.lstSums.Items.BeginUpdate;
          try
            Self.lstSums.Items.Add(FloatToStr(val));
          finally
            Self.lstSums.Items.EndUpdate;
          end;

          total := total + val;
        except
          raise Exception.Create('В таблице присутствуют недопустимые значения');
        end;
      end;

      Self.edtTotal.Text := FloatToStr(total)
    finally
      XLApp1.Workbooks.close;
    end;
  end;
end;

end.
