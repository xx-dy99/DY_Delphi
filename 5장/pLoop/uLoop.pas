unit uLoop;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    edtInput: TEdit;
    btnWhile: TButton;
    btnRepeat: TButton;
    ListBox1: TListBox;
    procedure btnWhileClick(Sender: TObject);
    procedure btnRepeatClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnWhileClick(Sender: TObject);
var
i,c,r:integer;
s:string;
begin
 i:=strtoint(edtInput.text);
 c:=1;
 r:=1;
 while c <= i do
 begin
   s:=s+inttostr(c)+'+';
   inc(c);
   r:=r+c;
 end;
 s:=s+inttostr(i)+'='+inttostr(r);
 ListBox1.items.Clear;
 ListBox1.items.add(s);
end;

procedure TForm1.btnRepeatClick(Sender: TObject);
var
 i,c,r:integer;
 s:string;
begin
i:=strtoint(edtinput.text);
c:=1;
r:=1;
 repeat
  s:=s+inttostr(c)+'+';
  inc(c);
  r:=r+c;
 until c = i;
s:=s+inttostr(i)+'='+inttostr(r);
ListBox1.items.Clear;
ListBox1.items.add(s);
end;

end.
