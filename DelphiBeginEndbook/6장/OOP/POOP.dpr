program POOP;

uses
  Forms,
  UOOP in 'UOOP.pas' {frmOop},
  uBus1 in 'uBus1.pas',
  uTruck1 in 'uTruck1.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmOop, frmOop);
  Application.Run;
end.
