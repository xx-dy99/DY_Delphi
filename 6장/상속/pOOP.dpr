program pOOP;

uses
  Forms,
  Uoop in 'Uoop.pas' {frmOOP},
  uTruck2 in 'uTruck2.pas',
  uBus2 in 'uBus2.pas',
  uBaseCar in 'uBaseCar.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmOOP, frmOOP);
  Application.Run;
end.
