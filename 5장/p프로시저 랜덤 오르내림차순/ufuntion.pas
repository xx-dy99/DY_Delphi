unit ufuntion;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, math; //폼의 uses절에 math추가 (근데 효과는 모르겠음 없어도 잘됨...

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edtInput: TEdit;
    btnRan: TButton;
    btnUpSort: TButton;
    btnDnSort: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Procedure Draw;//아마 프로시저 추가
    procedure btnRanClick(Sender: TObject);
    procedure btnUpSortClick(Sender: TObject);
    procedure btnDnSortClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function sort(flag:integer):boolean; //공통 작업인 실질적 정렬을 담당하는 함수
  end;

var
  Form1: TForm1;
  //임의로 발생한 숫자들과 정렬된 숫자들을 저장할 전역 배열
  Rand:array[0..4] of integer;

implementation

{$R *.DFM}

procedure TForm1.Draw;
var
  i:integer;
 begin
 ListBox2.Items.clear; //먼저 출력된 내용을 지운다.
 for i := 0 to 4 do begin //5번 순환.
  //배열에 저장된 정수 값을 리스트 박스에 출력
  ListBox2.Items.Add(inttostr(Rand[i]));
 end;//for
 end;

 function TForm1.sort(flag: integer):boolean;
 //정수형 값을 파라미터로 받고 불리언 값을 리턴
 var
 i,j,tmp:integer;
 begin
 tmp:=0;
 case flag of //case문 시작 파라미터로 넘어온 flag값이
  1:begin                 //1일 경우 오름차순 정렬 실시
   for i := 0 to 4 do
    for j := 0 to 4 do
     begin
     if Rand[j]>Rand[i] then
      begin
      tmp:=Rand[j];
      Rand[j]:=Rand[i];
      Rand[i]:=tmp;
      end;
     end;
    result:=true; //성공적으로 오름차순이 끝났음을 알려주기 위한 True값 리턴
    end;
  2:begin        //2일 경우 내림차순 정렬 실시
   for i := 0 to 4 do
    for j := 0 to 4 do
     begin
      if Rand[i]>Rand[j] then
       begin
        tmp:=Rand[i];
        Rand[i]:=Rand[j];
        Rand[j]:=tmp;
       end;
     end;
     result:=true;//성공적으로 내림차순이 끝났음을 알려주기 위한 True값 리턴
    end;
 end;
 end;
procedure TForm1.btnRanClick(Sender: TObject);
var
 i,j:integer;
begin
 j:=strtoint(edtInput.text); //입력받은 정수값(범위값)을 에디트 박스로 부터 가져옴
 Randomize;//임의의 수를 발생시키는  Random함수 사용을 위한 준비
 ListBox1.Items.clear;

 for i := 0 to 4 do  //5번 순환하면서 (배열의 개수만큼순환)
  begin
   Rand[i]:=Random(j);//배열에 차례로 임의의 수를 저장(Random함수이용)
  ListBox1.Items.Add(inttostr(Rand[i]));//첫번째 리스트 박스에 숫자가 발생한 순서대로 출력
  end;
end;

procedure TForm1.btnUpSortClick(Sender: TObject);
var
 R:boolean;
begin
 R:=sort(1);
 //오름차순을 위한 플래그로 정한 1을 파라미터로 해서 sort함수를 실행시킴
 if R then //sort함수가  true를 리턴을 리턴하면 정렬이 성공하면
 Draw   //리스트 박스 출력을 위한 프로시저 호출
 else
 showmessage('정렬 실패');
end;

procedure TForm1.btnDnSortClick(Sender: TObject);
var
R:boolean;
begin
R:=sort(2);
if R then
 Draw
 else
  showmessage('정렬 실패');
end;

end.
