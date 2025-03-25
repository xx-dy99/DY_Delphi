unit uRoomCount;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    edtNum: TEdit;
    edtCount: TEdit;
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
  a, n, sum : integer;
begin
  a := StrToInt(edtNum.Text);
  n := StrToInt(edtCount.Text);
  sum := (a + (a + n - 1)) * n div 2;

  if sum mod 2 = 0 then
  begin
    ShowMessage('������ �ִ� ��� ���� ��ȣ�� ���� ¦���Դϴ�.');
  end
  else
  begin
    ShowMessage('������ �ִ� ��� ���� ��ȣ�� ���� ¦���� �ƴմϴ�.');
  end;
end;

end.
