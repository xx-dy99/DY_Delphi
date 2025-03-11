unit uVariable;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    edtFirst: TEdit;
    edtSecond: TEdit;
    edtResult: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnCalc: TButton;
    btnReset: TButton;
    Label3: TLabel;
    lblCount: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCalcClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  c:integer;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  c:=0;
end;

procedure TForm1.btnCalcClick(Sender: TObject);
var
 i,j:integer;
begin
 i:=strtoint(edtFirst.text);
 j:=strtoint(edtSecond.text);
 edtResult.text:=inttostr(i-j);
 c:=c+1;
 lblCount.caption:=inttostr(c);
end;

procedure TForm1.btnResetClick(Sender: TObject);
begin
 c:=0;
 lblCount.caption:=inttostr(c);
end;

end.

//c는 전역변수로 밑에 버튼에 무슨 코드이던 따로 설정없이 사용이 가능하다.
//그리고 i 와 j는 지역변수로 그 이벤트핸들러가아니면 사용이 불가하다.