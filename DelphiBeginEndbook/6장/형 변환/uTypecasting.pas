unit uTypecasting;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N11: TMenuItem;
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
 if sender is TMenuItem then
 (Sender as TMenuItem).caption:='�޴� �׸� Ŭ��'
 else if Sender is TButton then
 (Sender as TButton).caption:='��Ʈ ��ưŬ��';
end;

end.
