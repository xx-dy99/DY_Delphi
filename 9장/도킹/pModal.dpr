program pModal;

uses
  Forms,
  uDoking in 'uDoking.pas' {MainForm},
  uModal in 'uModal.pas' {frmModal},
  uModuless in 'uModuless.pas' {frmModeless};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
