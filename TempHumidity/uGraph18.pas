unit uGraph18;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart;

type
  TForm3 = class(TForm)
    crtTempHum18: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
  private
    { Private declarations }
  public
    procedure AddData(Temperature, Humidity: Double);
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

procedure TForm3.AddData(Temperature, Humidity: Double);
var
  CurrentTime: TDateTime;
begin
  CurrentTime := Now; //현재시간가져오기

  Series1.AddXY(CurrentTime, Temperature);
  Series2.AddXY(CurrentTime, Humidity);
end;

end.
