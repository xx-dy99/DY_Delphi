unit uGraph1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart;

type
  TForm2 = class(TForm)
    chrtTempHum: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

end.
