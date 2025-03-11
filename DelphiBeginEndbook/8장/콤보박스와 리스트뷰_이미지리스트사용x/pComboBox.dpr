program pComboBox;

uses
  Forms,
  uComboBox in 'uComboBox.pas' {frmListView};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmListView, frmListView);
  Application.Run;
end.
