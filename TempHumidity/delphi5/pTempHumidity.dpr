program pTempHumidity;

uses
  Forms,
  uTempHumidity in 'uTempHumidity.pas' {Form1},
  uGraph1 in 'uGraph1.pas' {Form2},
  uGraph18 in 'uGraph18.pas' {Form3};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
