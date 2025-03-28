unit uQuadraticEquation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    edtA: TEdit;
    edtB: TEdit;
    edtC: TEdit;
    Button1: TButton;
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
  A, B, C, D, x, x1, x2 : Double;

begin
  A := StrToFloat(edtA.Text);
  B := StrToFloat(edtB.Text);
  C := StrToFloat(edtC.Text);

  if A = 0 then
  begin
    ShowMessage('A�� 0�� �ɼ� ����.');
    Exit;
  end;

  D := B * B - 4 * A * C;

  if D < 0 then
  begin
    ShowMessage('��ȿ�� �������� �����ϴ�');
  end
  else if D = 0 then
  begin
    x := -B / (2 * A);
    ShowMessage('�߱� :' +  FloatToStr(x));
  end
  else if D >0 then
  begin
    x1 := (-B + Sqrt(D)) / (2 * A);
    x2 := (-B - Sqrt(D)) / (2 * A);
    ShowMessage('�α� :' + FloatToStr(x1) + ',' + FloatToStr(x2));
  end;
end;

end.
