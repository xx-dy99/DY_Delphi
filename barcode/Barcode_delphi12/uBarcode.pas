unit uBarcode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, OoMisc, AdPort;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Memo1: TMemo;
    btnPortOpen: TButton;
    btnPortClose: TButton;
    btnTriggerScan: TButton;
    procedure btnPortOpenClick(Sender: TObject);
    procedure btnPortCloseClick(Sender: TObject);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTriggerScanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PartialData: string = '';

implementation

{$R *.dfm}

procedure TForm1.btnPortOpenClick(Sender: TObject);
begin
  if not Assigned(ApdComPort1) then
  begin
    ShowMessage('포트가 초기화 되지 않았습니다.');
    Exit;
  end;

  if ApdComPort1.Open then
  begin
    ShowMessage('이미 포트가 열려있습니다.');
    Exit;
  end;

  ApdComPort1.TriggerLength := 1;

  try
    ApdComPort1.Open := True;
    ShowMessage('포트가 열렸습니다.');
  except
    on E: Exception do
      ShowMessage('포트 열기 실패:' + E.Message);
  end;
end;

procedure TForm1.btnPortCloseClick(Sender: TObject);
begin
  if Assigned(ApdComPort1) and ApdComPort1.Open then
  begin
    ApdComPort1.Open := False;
    ShowMessage('포트가 닫혔습니다.');
  end
  else
    ShowMessage('포트가 이미 닫혀 있습니다.');
end;

procedure TForm1.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
var
  ReceivedData: array[0..255] of char;
  DataStr: string;
begin
  FillChar(ReceivedData, Sizeof(ReceivedData), 0);
  ApdComPort1.GetBlock(ReceivedData, Count);
  DataStr := StrPas(ReceivedData);

  if Pos(#2, DataStr) > 0 then
    PartialData := '';
  PartialData := PartialData + DataStr;

  PartialData := StringReplace(PartialData, #2, '', [rfReplaceAll]);
  PartialData := StringReplace(PartialData, #13, '', [rfReplaceAll]);
  PartialData := StringReplace(PartialData, #10, '', [rfReplaceAll]);

  if Length(PartialData) < 8 then Exit;

  if (Pos(#13, DataStr) > 0) or (Pos(#10, DataStr) > 0) then
  begin
    Memo1.Lines.Add(PartialData);
    PartialData:= '';
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(ApdComPort1) and ApdComPort1.Open then
  begin
    ApdComPort1.Open := False;
    ShowMessage('프로그램 종료: 포트가 닫혔습니다.');
  end;
end;

procedure TForm1.btnTriggerScanClick(Sender: TObject);
begin
  if ApdComPort1.Open then
  begin
    ApdComPort1.Output := #2;
    ShowMessage('스캔명령을 전송했씁니다.');
  end
  else
    ShowMessage('포트가 열려있지 않습니다.');
end;

end.
