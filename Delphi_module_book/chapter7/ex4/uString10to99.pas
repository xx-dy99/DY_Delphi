unit uString10to99;

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
  k, i : integer;
  s : string;
begin
  s := '';
  for i := 10 to 99 do
    s := s + IntToStr(i);

  k := StrToInt(edt1.Text);

  if (k < 1) or (180 < k) then
  begin
    ShowMessage('1과 180사이의 값을 입력해주세요');
    Exit;
  end
  else
  begin
    ShowMessage(Copy(s, k, 1));
  end;
end;

end.
