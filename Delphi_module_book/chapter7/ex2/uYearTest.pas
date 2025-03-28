unit uYearTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
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
  year : integer;
begin
  year := StrToInt(Edit1.Text);

  if ((year mod 4 = 0) and (year mod 100 <> 0)) or (year mod 400 = 0) then
  begin
    ShowMessage('윤년입니다');
    Exit;
  end
  else
  begin
    ShowMessage('평년입니다');
    Exit;
  end
end;

end.
