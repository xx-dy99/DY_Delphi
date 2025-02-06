unit ufuntion;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, math; //���� uses���� math�߰� (�ٵ� ȿ���� �𸣰��� ��� �ߵ�...

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edtInput: TEdit;
    btnRan: TButton;
    btnUpSort: TButton;
    btnDnSort: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Procedure Draw;//�Ƹ� ���ν��� �߰�
    procedure btnRanClick(Sender: TObject);
    procedure btnUpSortClick(Sender: TObject);
    procedure btnDnSortClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function sort(flag:integer):boolean; //���� �۾��� ������ ������ ����ϴ� �Լ�
  end;

var
  Form1: TForm1;
  //���Ƿ� �߻��� ���ڵ�� ���ĵ� ���ڵ��� ������ ���� �迭
  Rand:array[0..4] of integer;

implementation

{$R *.DFM}

procedure TForm1.Draw;
var
  i:integer;
 begin
 ListBox2.Items.clear; //���� ��µ� ������ �����.
 for i := 0 to 4 do begin //5�� ��ȯ.
  //�迭�� ����� ���� ���� ����Ʈ �ڽ��� ���
  ListBox2.Items.Add(inttostr(Rand[i]));
 end;//for
 end;

 function TForm1.sort(flag: integer):boolean;
 //������ ���� �Ķ���ͷ� �ް� �Ҹ��� ���� ����
 var
 i,j,tmp:integer;
 begin
 tmp:=0;
 case flag of //case�� ���� �Ķ���ͷ� �Ѿ�� flag����
  1:begin                 //1�� ��� �������� ���� �ǽ�
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
    result:=true; //���������� ���������� �������� �˷��ֱ� ���� True�� ����
    end;
  2:begin        //2�� ��� �������� ���� �ǽ�
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
     result:=true;//���������� ���������� �������� �˷��ֱ� ���� True�� ����
    end;
 end;
 end;
procedure TForm1.btnRanClick(Sender: TObject);
var
 i,j:integer;
begin
 j:=strtoint(edtInput.text); //�Է¹��� ������(������)�� ����Ʈ �ڽ��� ���� ������
 Randomize;//������ ���� �߻���Ű��  Random�Լ� ����� ���� �غ�
 ListBox1.Items.clear;

 for i := 0 to 4 do  //5�� ��ȯ�ϸ鼭 (�迭�� ������ŭ��ȯ)
  begin
   Rand[i]:=Random(j);//�迭�� ���ʷ� ������ ���� ����(Random�Լ��̿�)
  ListBox1.Items.Add(inttostr(Rand[i]));//ù��° ����Ʈ �ڽ��� ���ڰ� �߻��� ������� ���
  end;
end;

procedure TForm1.btnUpSortClick(Sender: TObject);
var
 R:boolean;
begin
 R:=sort(1);
 //���������� ���� �÷��׷� ���� 1�� �Ķ���ͷ� �ؼ� sort�Լ��� �����Ŵ
 if R then //sort�Լ���  true�� ������ �����ϸ� ������ �����ϸ�
 Draw   //����Ʈ �ڽ� ����� ���� ���ν��� ȣ��
 else
 showmessage('���� ����');
end;

procedure TForm1.btnDnSortClick(Sender: TObject);
var
R:boolean;
begin
R:=sort(2);
if R then
 Draw
 else
  showmessage('���� ����');
end;

end.
