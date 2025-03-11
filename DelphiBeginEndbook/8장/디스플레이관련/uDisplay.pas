unit uDisplay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    lblRed: TLabel;
    lblGreen: TLabel;
    lblBlue: TLabel;
    tbRed: TTrackBar;
    tbGreen: TTrackBar;
    tbBlue: TTrackBar;
    edtRed: TEdit;
    edtGreen: TEdit;
    edtBlue: TEdit;
    udRed: TUpDown;
    udGreen: TUpDown;
    udBlue: TUpDown;
    pbColor: TPaintBox;
    sbRed: TScrollBar;
    sbGreen: TScrollBar;
    sbBlue: TScrollBar;
    procedure tbRedChange(Sender: TObject);
    procedure udRedChanging(Sender: TObject; var AllowChange: Boolean);
    procedure sbRedChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.tbRedChange(Sender: TObject);
begin
pbColor.Canvas.Brush.color:=RGB(tbRed.position,tbBlue.position,tbGreen.position);
//각 트랙바의 position값으로 RGB색상값을 구해서 페인트 박스의 브러쉬 색상으로 지정한다.
pbColor.canvas.FillRect(pbColor.ClientRect);
udRed.position:=tbRed.position;
udBlue.position:=tbBlue.position;
udGreen.position:=tbGreen.position;

sbRed.position:=tbRed.position;
sbBlue.position:=tbBlue.position;
sbGreen.position:=tbGreen.position;

//각 레이블의 색상을 RGB값으로 칠한다
lblRed.Canvas.Brush.color:=RGB(tbRed.position,0,0);
lblRed.canvas.FillRect(lblRed.ClientRect);
lblGreen.canvas.Brush.color:=RGB(0,tbGreen.position,0);
lblGreen.canvas.FillRect(lblGreen.ClientRect);
lblBlue.canvas.Brush.color:=RGB(0,0,tbBlue.position);
lblBlue.canvas.FillRect(lblBlue.ClientRect);
end;

procedure TForm1.udRedChanging(Sender: TObject; var AllowChange: Boolean);
begin
pbColor.canvas.Brush.color:=RGB(udRed.position,udBlue.position,udGreen.position);
pbColor.canvas.FillRect(pbColor.ClientRect);

tbRed.position:=udRed.position;
tbBlue.position:=udBlue.position;
tbGreen.position:=udGreen.position;

sbRed.position:=udRed.position;
sbBlue.position:=udBlue.position;
sbGreen.position:=udGreen.position;

lblRed.Canvas.Brush.color:=RGB(udRed.position,0,0);
lblRed.canvas.FillRect(lblRed.ClientRect);
lblGreen.canvas.Brush.color:=RGB(0,udGreen.position,0);
lblGreen.canvas.FillRect(lblGreen.ClientRect);
lblBlue.canvas.Brush.color:=RGB(0,0,udBlue.position);
lblBlue.canvas.FillRect(lblBlue.ClientRect);
end;

procedure TForm1.sbRedChange(Sender: TObject);
begin
pbColor.canvas.Brush.color:=RGB(sbRed.position,sbBlue.position,sbGreen.position);
pbColor.canvas.FillRect(pbColor.ClientRect);

udRed.position:=sbRed.position;
udBlue.position:=sbBlue.position;
udGreen.position:=sbGreen.position;

tbRed.position:=sbRed.position;
tbBlue.position:=sbBlue.position;
tbGreen.position:=sbGreen.position;

lblRed.Canvas.Brush.color:=RGB(sbRed.position,0,0);
lblRed.canvas.FillRect(lblRed.ClientRect);
lblGreen.canvas.Brush.color:=RGB(0,sbGreen.position,0);
lblGreen.canvas.FillRect(lblGreen.ClientRect);
lblBlue.canvas.Brush.color:=RGB(0,0,sbBlue.position);
lblBlue.canvas.FillRect(lblBlue.ClientRect);
end;

end.


