unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
MyCaption, MyText : PChar;
begin
MyCaption := '������ 6!';
MyText := '�ڵ� �λ���Ʈ ����� �ð��� ������ ���!';
Application.MessageBox(MyText
end;

end.
