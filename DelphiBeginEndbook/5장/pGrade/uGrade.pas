unit uGrade;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtNum: TEdit;
    edtEng: TEdit;
    edtHst: TEdit;
    btnCalc: TButton;
    Label4: TLabel;
    lblAvrg: TLabel;
    Label6: TLabel;
    lblGrade: TLabel;
    procedure btnCalcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnCalcClick(Sender: TObject);
var
Total,Average:Integer;
begin
 if (edtNum.text<>'') and (edtEng.text<>'') and (edtHst.text<>'') then
  begin//바깥쪽 if절의 복합문 시작
   Total:=strtoint(edtEng.text)+strtoint(edtHst.text);
    //중첩된 안쪽의 if문 시작 - 100점 이상을 입ㄺ하지 못하도록 함
    if (strtoint(edtEng.text)>100) or (strtoint(edtHst.text)>100) then
        showmessage('점수입력을 다시 확인하세요')
    else begin
        Average:=round(Total/2);
        lblAvrg.caption:=inttostr(Average);
     end //중첩된 안쪽의 if문 끝
  end //바깥쪽 if문의 복합문끝
 else //바깥쪽 if문의 else절
 showmessage('값을 모두 입력해야 합니다!'); //바깥쪽 if문의 끝}

 case Average of
  90..100 : lblGrade.caption:='A';
  80..89 : lblGrade.caption:='B';
  70..79: lblGrade.caption:='C';
  else lblGrade.caption:='D';
 end;//case문의 끝
end;
end.
