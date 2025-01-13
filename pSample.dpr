program pSample;

uses
  Forms,
  uSample in 'uSample.pas' {frmSample};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSample, frmSample);
  Application.Run;
end.
