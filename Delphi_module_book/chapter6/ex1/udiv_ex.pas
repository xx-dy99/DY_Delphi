unit udiv_ex;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    edtM: TEdit;
    edtN: TEdit;
    Label1: TLabel;
    btnDiv: TButton;
    procedure btnDivClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnDivClick(Sender: TObject);
var
  m, n: integer;
begin
  m := StrToInt(edtM.Text);
  n := StrToInt(edtN.Text);
  if (n mod m = 0) then
  begin
  //label1.Caption := n / m
  label1.Caption := IntToStr(n div m);
  end
  else
  begin
    label1.Caption := ' n은 m으로 나눌수 없습니다.'
  end;
end;

end.

{begin
if then
begin
end
else
begin
end;
end;
}
