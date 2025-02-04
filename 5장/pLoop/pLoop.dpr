program pLoop;

uses
  Forms,
  uLoop in 'uLoop.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
