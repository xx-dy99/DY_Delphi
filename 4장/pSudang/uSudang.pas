unit uSudang;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtA: TEdit;
    edtB: TEdit;
    edtC: TEdit;
    btnInput: TButton;
    StatusBar1: TStatusBar;
    procedure btnInputClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnInputClick(Sender: TObject);
var
 a,b,c:boolean;
 y,z:integer;
begin
 y:=strtoint(edtB.text);
 z:=strtoint(edtC.text);
 //변수를 이용하지않고 직접 불린값을 추출
 a:=(strtoint(edtA.text)>=10000) and (strtoint(edtA.text)<=100000) and (strtoint(
   edtA.text) mod 10 = 0);
   //변수를 이용해서 불린값 추출
 b:= ((y>=10000) and (y<=100000)) and (y mod 10 = 0); //<<and연산자의 사용법에주목

 c:= ((z>=10000) and (z<=100000)) and (z mod 10 = 0);

 //경우에 수에 따라 입력 성공과 실패 여부 추력
 if (a and b and c) then
 StatusBar1.SimpleText := '입력성공'
 else if (not a) and (not b) and (not c) then //not연산자의 사용법에 주목
 StatusBar1.SimpleText := '입력실패'
 else if (not b) and (not c) then
  StatusBar1.SimpleText:='김연아와 손흥민의 수당 입력 실패'
 else if (not a) and (not c) then
  StatusBar1.SimpleText:='페이커와 손흥민의 수당 입력 실패'
 else if (not a) and (not b) then
  StatusBar1.SimpleText:='페이커와 김연아의 수당 입력 실패'
 else if (not a) then
 StatusBar1.SimpleText:='페어커의 수당 입력 실패'
 else if (not b) then
 StatusBar1.SimpleText:='김연아의 수당 입력 실패'
 else if (c=false) then //not을 사용하지않고 값을 비교
 StatusBar1.SimpleText:='손흥민의 수당 입력 실패'

end;

end.
