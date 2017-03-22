program test2;

uses
  Forms,
  main_u in 'main_u.pas' {frmMain},
  child_u in 'child_u.pas' {frmChild};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
