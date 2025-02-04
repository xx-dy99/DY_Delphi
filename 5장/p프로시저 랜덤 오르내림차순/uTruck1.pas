unit uTruck1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtTrkEngine: TEdit;
    edtTrkYear: TEdit;
    edtTrkColor: TEdit;
    edtBsEngine: TEdit;
    edtBsYear: TEdit;
    edtBsColor: TEdit;
    chkbxLoeading: TCheckBox;
    chkbxPassanger: TCheckBox;
    btnCreateTruck: TButton;
    btnCreateBus: TButton;
    Engine,Yrar: integer;
    Color:String;
    HasPack:boolean;
    Constructor Create;
    Destructor Destroy;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Constructor TTruck.Create;
begin
 Engine:=3000;
 Year:=1998;
 Color:='blue';
 HasPack:=True;
end;

Destructor TTruck.Destroy;
begin
end;
end.
