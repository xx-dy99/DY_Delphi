unit u353;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    edt1: TEdit;
    btn1: TButton;
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
  i, d, m: integer;
begin
  i := StrToInt(edt1.Text);

  if (i<100) or (i > 999) then
  begin
    ShowMessage('���ڸ��� ������ �Է����ּ���!');
    Exit;
  end;
  
  d := i div 100;
  m := i mod 10;
  if d = m then
  begin
    ShowMessage('�յڰ� �Ȱ��� ���� �Դϴ�');
  end
  else
  begin
    ShowMessage('�յ� ���ڰ� �ٸ��ϴ� �ٽ��Է����ּ���');
  end;
end;

end.
