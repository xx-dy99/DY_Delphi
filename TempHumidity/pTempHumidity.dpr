program pTempHumidity;

uses
  Forms,
  uTempHumidity in 'uTempHumidity.pas' {Form1},
  uGraph in 'uGraph.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
