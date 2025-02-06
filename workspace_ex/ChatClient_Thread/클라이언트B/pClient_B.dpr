program pClient_B;

uses
  Forms,
  uClient in '..\클라이언트A\uClient.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
