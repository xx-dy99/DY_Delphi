unit uTripleAndAvg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    edt1: TEdit;
    edt2: TEdit;
    btn1: TButton;
    X: TLabel;
    Label2: TLabel;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btn1Click(Sender: TObject);
var
  X, Y, avg : Double;
begin
  X := StrToFloat(edt1.Text);
  Y := StrToFloat(edt2.Text);
  avg := (X + Y) / 2;
  if X = Y then
  begin
    ShowMessage('X와 Y의 수를 다르게 입력해주세요');
    Exit;
  end;
  if X > Y then
  begin
    X := X * 3;
    Y := avg;
    ShowMessage(FloatToStr(X) + #13#10 + FloatToStr(Y));
  end
  else
  begin
    X := avg;
    Y := Y * 3;
    ShowMessage(FloatToStr(X) + #13#10 + FloatToStr(Y));
  end;
end;

end.
