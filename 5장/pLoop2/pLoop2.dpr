program pLoop2;

uses
  Forms,
  uLoop2 in 'uLoop2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
