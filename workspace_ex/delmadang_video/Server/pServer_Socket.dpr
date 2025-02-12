program pServer_Socket;

uses
  Forms,
  uServer_Socket in 'uServer_Socket.pas' {fmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
