unit uEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
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
begin
 Label1.Caption := Edit1.Text; //�󺧿� �ؽ�Ʈ�ڽ��� �ؽ�Ʈ�� ����
 Edit1.Text := ''; // �ؽ�Ʈ�ڽ��� �ؽ�Ʈ�� �������� ����...
end;

end.
