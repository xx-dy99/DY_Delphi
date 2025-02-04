unit Uoop;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmOOP = class(TForm)
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
  frmOOP: TfrmOOP;

implementation

uses uBaseCar, uBus2, uTruck2;

{$R *.DFM}

procedure TfrmOOP.btnCreateTruckClick(Sender: TObject);
var
Truck2:TTruck2;
begin
Truck2:=TTruck2.Create;
with Truck2 do
begin
 edtTrkEngine.text:=IntToStr(Engine);
 edtTrkYear.text:=IntToStr(Year);
 edtTrkColor.text:=Color;
 chkbxLoading.Checked:=HasPack;
end;
end;

procedure TfrmOOP.btnCreateBusClick(Sender: TObject);
var
Bus2:TBus2;
begin
Bus2:=TBus2.Create;
with Bus2 do
begin
 edtBsEngine.Text:=IntToStr(Engine);
 edtBsYear.Text:=IntToStr(Year);
 edtBsColor.Text:=Color;
 chkbxPassanger.Checked:=HasPassanger;
end;
end;

end.
