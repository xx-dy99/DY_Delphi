unit code_insight;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
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
MyCaption, MyText : PChar;
begin;
MyCaption := '델파이 6!';
MyText := '코드 인사이트 기능은 시간을 절약해 줘요!';
Application.MessageBox (MyText,MyCaption,MB_OK);
if  then
begin

end
else
begin

end;

end;
            "Message Box (

end.
