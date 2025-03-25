program pdiv_ex;

uses
  Forms,
  udiv_ex in 'udiv_ex.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
