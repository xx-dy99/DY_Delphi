unit uBarcode;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OoMisc, AdPort;

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
  PartialData: string = ''; //바코드 데이터를 누적 저장하는 변수

implementation

{$R *.DFM}

procedure TForm1.btnPortOpenClick(Sender: TObject);
begin
  if not Assigned(ApdComPort1) then
  begin
    ShowMessage('포트가 초기화 되지 않았습니다.');
    Exit;
  end;

  if ApdComport1.Open then
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
      ShowMessage('포트열기 실패:' + E.Message);
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
  ReceivedData: array[0..255] of char; //최대 256바이트 읽기
  DataStr: string;
begin
  FillChar(ReceivedData, Sizeof(ReceivedData), 0); //배열 초기화
  ApdComPort1.GetBlock(ReceivedData, Count); //데이터 읽기
  DataStr := StrPas(ReceivedData); //PChar -> String변환

  if Pos(#2, DataStr) > 0 then  // <STX> 감지 시 새로운 바코드 시작
    PartialData := '';

  PartialData := PartialData + DataStr;// 데이터 누적 저장

  // <STX>, <CR>, <LF> 제거
  PartialData := StringReplace(PartialData, #2, '', [rfReplaceAll]);  
  PartialData := StringReplace(PartialData, #13, '', [rfReplaceAll]); 
  PartialData := StringReplace(PartialData, #10, '', [rfReplaceAll]);

  if Length(PartialData) < 8 then Exit;// 너무 짧은 데이터 무시

  if (Pos(#13, DataStr) > 0) or (Pos(#10, DataStr) > 0) then
  begin
    Memo1.Lines.Add(PartialData);
    PartialData := '';
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
    //ApdComPort1.PutChar(#2);
    ApdComPort1.Output := #2;
    ShowMessage('스캔 명령을 전송했습니다.');
  end
  else
    ShowMessage('포트가 열려있지 않습니다.');
end;

end.
