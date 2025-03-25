program pTempChange;

uses
  Forms,
  uTempChange in 'uTempChange.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
