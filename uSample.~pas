unit uSample;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmSample = class(TForm)
    edtFirst: TEdit;
    edtSecond: TEdit;
    lblFirst: TLabel;
    lblSecond: TLabel;
    btnCheck: TButton;
    procedure btnCheckClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSample: TfrmSample;

implementation

{$R *.DFM}

procedure TfrmSample.btnCheckClick(Sender: TObject);
begin
lblFirst.Caption := edtFirst.Text;
lblSecond.Caption := edtSecond.Text;
end;

end.
