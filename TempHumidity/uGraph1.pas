unit uGraph1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart;

type
  TForm2 = class(TForm)
    chrtTempHum1: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
  private
    { Private declarations }
  public
    procedure AddData(Temperature, Humidity: Double);
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.AddData(Temperature, Humidity: Double);
var
  CurrentTime: TDateTime;
begin
  CurrentTime := Now; //현재시간가져오기

  Series1.AddXY(CurrentTime, Temperature);
  Series2.AddXY(CurrentTime, Humidity);
end;

end.
