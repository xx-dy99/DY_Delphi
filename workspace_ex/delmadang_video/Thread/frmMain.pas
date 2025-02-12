unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Rainbow;

type
  TForm1 = class(TForm)
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    btnStart: TButton;
    btnStop: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Rainbow1, Rainbow2, Rainbow3 : TRainbow;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
 Rainbow1:= TRainbow.Create(true);
 Rainbow1.Shape:= Shape1;

 Rainbow2:= TRainbow.Create(true);
 Rainbow2.Shape:= Shape2;

 Rainbow3:= TRainbow.Create(true);
 Rainbow3.Shape:= Shape3;
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
 Rainbow1.Resume;
 Rainbow2.Resume;
 Rainbow3.Resume;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
 Rainbow1.Suspend;
 Rainbow2.Suspend;
 Rainbow3.Suspend;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=false;
 try
 Shape1.Brush.Color:=
  Round(Random(256)) shl 16 +
  Round(Random(256)) shl 8 +
  Round(Random(256));
 finally
  Timer1.Enabled:=true;
 end;
end;

end.
