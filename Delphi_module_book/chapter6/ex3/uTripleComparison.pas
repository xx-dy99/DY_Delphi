unit uTripleComparison;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    edt1: TEdit;
    Button1: TButton;
    edt2: TEdit;
    edt3: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  a, b, c, max, min: Double;
begin
  a := StrToFloat(edt1.Text);
  b := StrToFloat(edt2.Text);
  c := StrToFloat(edt3.Text);

  max := a;
  min := a;

  if b > max then
    max := b;
    if c > max then
      max := c;

  if b < min then
    min := b;
    if c < min then
      min := c;

  ShowMessage('ÃÖ´ñ°ª: ' + FloatToStr(max) +#13#10 + 'ÃÖ¼Ú°ª:' + FloatToStr(min));
end;

end.
