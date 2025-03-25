unit uTempChange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    btnChangeCe: TButton;
    Edit1: TEdit;
    btnChangeFa: TButton;
    Label1: TLabel;
    procedure btnChangeCeClick(Sender: TObject);
    procedure btnChangeFaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  celsius, fahrenheit: Double;

implementation

{$R *.DFM}

procedure TForm1.btnChangeCeClick(Sender: TObject);
begin
  fahrenheit := StrToFloat(Edit1.Text);
  celsius := (fahrenheit - 32) * 5 / 9;
  label1.Caption := Format('ȭ��%.1f�� -> ����%.1f��', [fahrenheit, celsius]);
end;

procedure TForm1.btnChangeFaClick(Sender: TObject);
begin
  celsius := StrToFloat(Edit1.Text);
  fahrenheit := celsius * 9 / 5 + 32;
  label1.Caption := Format('����%.1f�� -> ȭ��%.1f��', [celsius, fahrenheit]);
end;

end.
