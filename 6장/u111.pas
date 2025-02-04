unit u111;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, StdCtrls, ComCtrls, Buttons;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edtName: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    FindDialog1: TFindDialog;
    RichEdit1: TRichEdit;
    btnSearch: TButton;
    cbFont: TComboBox;
    mePhone: TMaskEdit;
    sbSort: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure sbSortClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FindDialog1Close(Sender: TObject);
    procedure mePhoneKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbFontClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  s1,s2:string; //입력 스트링 저장을 위한 전역 변수 선언

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
cbFont.Items := Screen.Fonts;//폼이 만드러질때 스크린 객체가 가지고있는 
                            //폰트들을 콤보박스레 할당해둔다.
end;

procedure TForm1.mePhoneKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if key = VK_SPACE then //스페이스를 눌러도
 key := VK_RIGHT //오른쪽 화살표키를 누른것처럼 효과를 냅니다.
end;

procedure TForm1.Button1Click(Sender: TObject);
var
s:string;
begin
s1 := edtName.Text;
s2 := mePhone.Text;
s := s1 + '' + s2;
Memo1.Lines.Clear;//먼저입력된 메모 컴포넌트 내용을 지운다.
Memo1.Lines.Add(s);//새 정보를 입력한다.
end;

procedure TForm1.sbSortClick(Sender: TObject);
begin
with RichEdit1 do
begin
Lines.Clear;
 Paragraph.Numbering := nsBullet; //문단 첫머리에 점을찍는다.
 Paragraph.FirstIndent := 5; //들여쓰기를 5로지정한다.
 Lines.Add(s1);
 Paragraph.Numbering := nsNone;
 Paragraph.FirstIndent := 25;
 Lines.Add('전화: '+ s2);
end;
end;

procedure TForm1.btnSearchClick(Sender: TObject);
begin
FindDialog1.Execute;
end;

procedure TForm1.FindDialog1Close(Sender: TObject);
Var
I,J,PosReturn,SkipChars:integer;
begin
for I:=0 to Memo1.Lines.Count do
begin
PosReturn:= Pos(FindDialog1.FindText, Memo1.Lines[I]);
if PosReturn <> 0 then
begin
 SkipChars:= 0;
 for J:= 0 to I -1 do
  Skipchars := Skipchars + Length(Memo1.Lines[J]);
  SkipChars := SkipChars +(I*2);
  SkipChars := SkipChars +PosReturn-1;

  Memo1.SetFocus;
  Memo1.SelStart:=SkipChars;
  Memo1.SelLength:=Length(FindDialog1.FindText);
  break;
end;
end;
end;

procedure TForm1.cbFontClick(Sender: TObject);
begin
RichEdit1.Font.Name := cbFont.Items[cbFont.ItemIndex];
RichEdit1.Font.Size:=12;
end;

end.
