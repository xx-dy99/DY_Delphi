unit uKmToMs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    edtInput: TEdit;
    btnKmToMs: TButton;
    btnMsToKm: TButton;
    lblResult: TLabel;
    procedure btnKmToMsClick(Sender: TObject);
    procedure btnMsToKmClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnKmToMsClick(Sender: TObject);
var
  Km, MS: Double;
begin
  Km := StrToFloat(edtInput.Text);
  Ms := Km * 5 / 18;
  //lblResult.Caption := FloatToStr(MS);
  lblResult.Caption := Format('%.2f m/s', [MS]);
end;

procedure TForm1.btnMsToKmClick(Sender: TObject);
var
  Km, Ms: Double;
begin
  Ms := StrToFloat(edtInput.Text);
  Km := Ms * 18 / 5;
  lblResult.Caption := Format('%.2f km/h', [Km]);
end;

end.
