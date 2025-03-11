unit u3Lable;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
 Label1.Enabled := true;
 Label2.Enabled := False;
 Label3.Enabled := False;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Label1.Enabled := False;
 Label2.Enabled := true;
 Label3.Enabled := False;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 Label1.Enabled := False;
 Label2.Enabled := False;
 Label3.Enabled := True;
end;

end.
