unit uStringSample;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtInput: TEdit;
    edtLen: TEdit;
    edtInsert: TEdit;
    edtDelete: TEdit;
    edtPos: TEdit;
    Label6: TLabel;
    lblString: TLabel;
    edtCopy: TEdit;
    btnInfo: TButton;
    btnHandle: TButton;
    procedure btnInfoClick(Sender: TObject);
    procedure btnHandleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnInfoClick(Sender: TObject);
var
 S:widestring;
begin
 edtLen.text := inttostr(Length(edtInput.text));
 S := edtInput.text;
 edtCopy.text := copy(S,5,6);
end;

procedure TForm1.btnHandleClick(Sender: TObject);
var
 S:wideString;
begin
 S := lblString.caption;
 insert('°¡°¡ ',S,4);
 edtInsert.text := S;
 Delete(S,2,5);
 edtDelete.text := S;
 While Pos(' ', S) > 0 do
  S[Pos(' ', S)] := '0';
 edtPos.text := S;
end;

end.
