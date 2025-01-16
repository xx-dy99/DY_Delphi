unit ucalculator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    edtFirst: TEdit;
    edtSecond: TEdit;
    edtResult: TEdit;
    lblOperator: TLabel;
    Panel1: TPanel;
    sbtnPlus: TButton;
    Label2: TLabel;
    sptnMinus: TButton;
    sbtnMod: TButton;
    sbtnDevide: TButton;
    sbtnMultiple: TButton;
    procedure sbtnPlusClick(Sender: TObject);
    procedure sptnMinusClick(Sender: TObject);
    procedure sbtnMultipleClick(Sender: TObject);
    procedure sbtnDevideClick(Sender: TObject);
    procedure sbtnModClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.sbtnPlusClick(Sender: TObject);
var
 i,j: real;
begin
 lblOperator.caption:='+';
 i:=strtofloat(edtFirst.text);
 j:=strtofloat(edtSecond.text);
 edtResult.text:=floattostr(i+j);
end;

procedure TForm1.sptnMinusClick(Sender: TObject);
var
 i,j:Real;
begin
 lblOperator.caption:='-';
 i:=strtofloat(edtFirst.text);
 j:=strtofloat(edtSecond.text);
 edtResult.text:=floattostr(i-j);
end;

procedure TForm1.sbtnMultipleClick(Sender: TObject);
var
 i,j:Real;
begin
 lblOperator.caption:='*';
 i:=strtofloat(edtFirst.text);
 j:=strtofloat(edtSecond.text);
 edtResult.text:=floattostr(i*j);
end;

procedure TForm1.sbtnDevideClick(Sender: TObject);
var
 i,j:Real;
begin
 lblOperator.caption:='/';
 i:=strtofloat(edtFirst.text);
 j:=strtofloat(edtSecond.text);
 edtResult.text:=floattostr(i/j);
end;

procedure TForm1.sbtnModClick(Sender: TObject);
var
 i,j:integer;
begin
 lblOperator.caption:='M';
 i:=strtoint(edtFirst.text);
 j:=strtoint(edtSecond.text);
 edtResult.text:=inttostr(i Mod j);
end;

end.
