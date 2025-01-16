unit Umultiple;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    btnMultiple: TButton;
    edtFirst: TEdit;
    edtSecond: TEdit;
    lblFirst: TLabel;
    lblSecond: TLabel;
    lblResult: TLabel;
    procedure btnMultipleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnMultipleClick(Sender: TObject);
var
F,L : integer;
begin
 F := strtoint(edtFirst.text);
 L := strtoint(edtSecond.text);
 lblResult.Caption := inttostr(F*L);
end;

end.
