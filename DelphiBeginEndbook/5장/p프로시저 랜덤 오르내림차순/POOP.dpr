program POOP;

uses
  Forms,
  uTruck1 in 'uTruck1.pas' {Form1},
  uBus1 in 'uBus1.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
