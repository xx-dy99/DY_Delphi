unit uLoop2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    edtInput: TEdit;
    btnFor: TButton;
    lblResult: TLabel;
    procedure btnForClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnForClick(Sender: TObject);
var
i,j:integer;
s:string;

begin
j:=strtoint(edtInput.text);
for i := 1 to j do
 begin
 if (i mod 4)=0 then
 s:=s+inttostr(i)+',';
 if (i mod 20)=0 then
 s:=s+#13;
 end;
 lblResult.caption:=s;
end;

end.
