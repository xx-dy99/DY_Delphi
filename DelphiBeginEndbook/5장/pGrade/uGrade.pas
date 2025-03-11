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
  begin//�ٱ��� if���� ���չ� ����
   Total:=strtoint(edtEng.text)+strtoint(edtHst.text);
    //��ø�� ������ if�� ���� - 100�� �̻��� �Ԥ����� ���ϵ��� ��
    if (strtoint(edtEng.text)>100) or (strtoint(edtHst.text)>100) then
        showmessage('�����Է��� �ٽ� Ȯ���ϼ���')
    else begin
        Average:=round(Total/2);
        lblAvrg.caption:=inttostr(Average);
     end //��ø�� ������ if�� ��
  end //�ٱ��� if���� ���չ���
 else //�ٱ��� if���� else��
 showmessage('���� ��� �Է��ؾ� �մϴ�!'); //�ٱ��� if���� ��}

 case Average of
  90..100 : lblGrade.caption:='A';
  80..89 : lblGrade.caption:='B';
  70..79: lblGrade.caption:='C';
  else lblGrade.caption:='D';
 end;//case���� ��
end;
end.
