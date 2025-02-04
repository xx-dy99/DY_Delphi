unit UOOP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmOop = class(TForm)
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtBsEngine: TEdit;
    edtBsYear: TEdit;
    edtBsColor: TEdit;
    chkbxPassanger: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtTrkEngine: TEdit;
    edtTrkYear: TEdit;
    edtTrkColor: TEdit;
    chkbxLoading: TCheckBox;
    btnCreateTruck: TButton;
    btnCreateBus: TButton;
    procedure btnCreateTruckClick(Sender: TObject);
    procedure btnCreateBusClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOop: TfrmOop;

implementation

uses uBus1, uTruck1;

{$R *.DFM}

procedure TfrmOop.btnCreateTruckClick(Sender: TObject);
var
Truck1:TTruck;
begin
Truck1:=TTruck.Create;
with Truck1 do
begin
 edtTrkEngine.text:=IntToStr(Engine);
 edtTrkYear.text:=IntToStr(Year);
 edtTrkColor.text:=Color;
 chkbxLoading.Checked:=HasPack;
end;
end;

procedure TfrmOop.btnCreateBusClick(Sender: TObject);
var
Bus1:TBus;
begin
Bus1:=TBus.Create;
with Bus1 do
begin
 edtBsEngine.Text:=IntToStr(Engine);
 edtBsYear.Text:=IntToStr(Year);
 edtBsColor.Text:=Color;
 chkbxPassanger.Checked:=HasPassanger;
end;
end;
end.
