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
 //������ �̿������ʰ� ���� �Ҹ����� ����
 a:=(strtoint(edtA.text)>=10000) and (strtoint(edtA.text)<=100000) and (strtoint(
   edtA.text) mod 10 = 0);
   //������ �̿��ؼ� �Ҹ��� ����
 b:= ((y>=10000) and (y<=100000)) and (y mod 10 = 0); //<<and�������� �������ָ�

 c:= ((z>=10000) and (z<=100000)) and (z mod 10 = 0);

 //��쿡 ���� ���� �Է� ������ ���� ���� �߷�
 if (a and b and c) then
 StatusBar1.SimpleText := '�Է¼���'
 else if (not a) and (not b) and (not c) then //not�������� ������ �ָ�
 StatusBar1.SimpleText := '�Է½���'
 else if (not b) and (not c) then
  StatusBar1.SimpleText:='�迬�ƿ� ������� ���� �Է� ����'
 else if (not a) and (not c) then
  StatusBar1.SimpleText:='����Ŀ�� ������� ���� �Է� ����'
 else if (not a) and (not b) then
  StatusBar1.SimpleText:='����Ŀ�� �迬���� ���� �Է� ����'
 else if (not a) then
 StatusBar1.SimpleText:='���Ŀ�� ���� �Է� ����'
 else if (not b) then
 StatusBar1.SimpleText:='�迬���� ���� �Է� ����'
 else if (c=false) then //not�� ��������ʰ� ���� ��
 StatusBar1.SimpleText:='������� ���� �Է� ����'

end;

end.
