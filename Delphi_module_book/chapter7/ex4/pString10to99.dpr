program pString10to99;

uses
  Forms,
  uString10to99 in 'uString10to99.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
