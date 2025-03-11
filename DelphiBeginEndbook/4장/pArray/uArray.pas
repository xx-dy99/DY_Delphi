unit uArray;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, TntGrids;

type
  TMyIntArray = Array of Integer; //Integer형의 동적 배열 선언

  TForm1 = class(TForm)
    edtFirst: TEdit;
    edtForth: TEdit;
    edtSecond: TEdit;
    edtThird: TEdit;
    btnStaticArray: TButton;
    btnDynamicArray: TButton;
    edtSize: TEdit;
    Label1: TLabel;
    StringGrid1: TTntStringGrid;
    ListBox1: TListBox;
    procedure btnStaticArrayClick(Sender: TObject);
    procedure btnDynamicArrayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnStaticArrayClick(Sender: TObject);
type
 TTable = array[0..1, 0..1] of string; //2차원스트링형 배열 선언
var
 MyTable:TTable; //TTable에 대한 변수 선언
 Col,Row:integer;
begin
 MyTable[0,0]:=edtFirst.Text;
 MyTable[1,0]:=edtSecond.Text;
 MyTable[0,1]:=edtThird.Text;
 MyTable[1,1]:=edtForth.Text;

 for Col:=0 to 1 do
  for Row :=0 to 1 do
   StringGrid1.Cells[Col,Row]:=MyTable[Col,Row];
end;

procedure TForm1.btnDynamicArrayClick(Sender: TObject);
var
 A,B:TMyIntArray;//동적 배열의 변수 선언
 Size,index : integer;
begin
 Size:=StrToInt(edtSize.Text);
 SetLength(A,Size);
 for Size := 0 to Size-1 do
 begin
 A[Size]:=sqr(size);
 end;

 B:=A;
 ListBox1.items.Clear;
 for index := Low(B) to High(B) do
 begin
  ListBox1.Items.Add(InttoStr(B[index]));
 end;
end;

end.
