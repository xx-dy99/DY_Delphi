program pTempHum12;

uses
  Vcl.Forms,
  uTempHum12 in 'uTempHum12.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
