unit uCal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    btnAdd: TButton;
    btnSub: TButton;
    btnMul: TButton;
    btnDiv: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnSubClick(Sender: TObject);
    procedure btnMulClick(Sender: TObject);
    procedure btnDivClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  num1, num2, result: Double;

implementation

{$R *.DFM}

procedure TForm1.btnAddClick(Sender: TObject);
begin
  num1 := StrToFloat(Edit1.Text);
  num2 := StrToFloat(Edit2.Text);
  result := num1 + num2;
  Label1.Caption := '결과 : ' +FloatToStr(result);
end;

procedure TForm1.btnSubClick(Sender: TObject);
begin
  num1 := StrToFloat(Edit1.Text);
  num2 := StrToFloat(Edit2.Text);
  result := num1 - num2;
  label1.Caption := '결과 : ' + FloatToStr(result);
end;

procedure TForm1.btnMulClick(Sender: TObject);
begin
  num1 := StrToFloat(Edit1.Text);
  num2 := StrToFloat(Edit2.Text);
  result := num1 * num2;
  label1.Caption := '결과 :' + FloatToStr(result);
end;

procedure TForm1.btnDivClick(Sender: TObject);
begin
  num1 := StrToFloat(Edit1.Text);
  num2 := StrToFloat(Edit2.Text);
  if num2 = 0 then
    label1.Caption := '0으로 나눌수 없습니다.'
    else
    begin
    result := num1 / num2;
    label1.Caption := '결과: ' + FloatToStr(result);
    end;
end;

end.
