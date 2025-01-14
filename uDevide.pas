unit uDevide;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    btnDevide: TButton;
    edtFirst: TEdit;
    edtSecond: TEdit;
    Label2: TLabel;
    lblResult: TLabel;
    lblgiho: TLabel;
    procedure btnDevideClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnDevideClick(Sender: TObject);
var
 F : real;
 L : double;
begin
 F := strtofloat(edtFirst.text);
 L := strtofloat(edtSecond.text);
 lblResult.caption := floattostr(F / L);
end;

end.
