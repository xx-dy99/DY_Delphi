unit uBarcode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, OoMisc, AdPort, AdPacket;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Memo1: TMemo;
    btnPortOpen: TButton;
    btnPortClose: TButton;
    btnTriggerScan: TButton;
    ApdDataPacket1: TApdDataPacket;
    procedure btnPortOpenClick(Sender: TObject);
    procedure btnPortCloseClick(Sender: TObject);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTriggerScanClick(Sender: TObject);
    procedure ApdDataPacket1StringPacket(Sender: TObject; Data: AnsiString);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  //기존 PartialData: string = '';
  PartialData: AnsiString = '';
  DataStr : AnsiString; //받은데이터를 저장할 문자열 변수선언 AnsiString으로 받음

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

  ApdComPort1.TriggerLength := 1; //바코드리더기가 데이터를 1바이트 받으면.

  try //오류(예외)가 발생할수있는 코드블룩 시작 발생할경우 except블록으로 이동하여 오류를 처리.
    ApdComPort1.Open := True; //바코드 데이터를 받을준비함.
    ShowMessage('포트가 열렸습니다.');
  except
    on E : Exception do //예외(오류)를 잡아서 E라는 변수에 저장하고 오류메시지 확인.
      ShowMessage('포트 열기 실패:' + E.Message);
  end;
end;

procedure TForm1.ApdDataPacket1StringPacket(Sender: TObject; Data: AnsiString);
var
  len : word; //len을 word로 선언 word = 2byte
begin
  exit;
  len := Length(data); // len에 data의 길이를 대입
  Memo1.Lines.Add(Data + '('+ InttoStr(len) +')' );
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
  I : Integer; //추가 , 반복문에서 사용할 변수
  ch : AnsiChar;
  str : AnsiString;
begin

  for i := 1 to count do begin // i를 1로 초기화하고 count까지 실행

     ch := ApdComPort1.GetChar;
     DataStr := DataStr + ch;
  end;

  if Length(DataStr) <> 11 then exit;

  str := DataStr + Format('(length:%d)', [Length(DataStr)]);
  Memo1.Lines.Add(DataStr + str);

  exit;
  FillChar(ReceivedData, Sizeof(ReceivedData), 0); //ReceivedData 0으로 초기화
  ApdComPort1.GetBlock(ReceivedData, Count); //받은데이터를 ReceivedData에 저장

  //추가 바이트 데이터를 AnsiString으로 변환
  //SetLength(DataStr, Count);
  for I := 0 to Count - 1 do
    DataStr:= DataStr + AnsiChar(ReceivedData[I]);

  if Length(DataStr) <> 11 then exit;
  

  //<STX>감지 시 새로운 바코드 시작
  if Pos(#2, DataStr) > 0 then
    PartialData := '';

  //데이터 누적 저장
  PartialData := PartialData + DataStr;

  // <STX>, <CR>, <LF> 제거
  PartialData := StringReplace(PartialData, #2, '', [rfReplaceAll]);
  PartialData := StringReplace(PartialData, #13, '', [rfReplaceAll]);
  PartialData := StringReplace(PartialData, #10, '', [rfReplaceAll]);

  // 너무 짧은 데이터 무시
  //if Length(PartialData) < 8 then Exit;

  if (Pos(#13, DataStr) > 0) or (Pos(#10, DataStr) > 0) then
  begin
    //기존 Memo1.Lines.Add(PartialData);
    Memo1.Lines.Add(string(PartialData));//추가 AnsiString을 Unicode로변환후 Memo1에 추가
    Memo1.SelStart := Length(Memo1.Text); //자동스크롤 이동
    SendMessage(Memo1.Handle, WM_VSCROLL, SB_BOTTOM, 0); //추가스크롤 최하단 이동
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
  // 기존 (제거)DataStr := StrPas(ReceivedData);
  if ApdComPort1.Open then
  begin
    DataStr := '';
    ApdComPort1.FlushInBuffer;
    ApdComPort1.FlushOutBuffer;

    ApdComPort1.Output := #2;
    //ShowMessage('스캔명령을 전송했습니다.');
  end
  else
    ShowMessage('포트가 열려있지 않습니다.');
end;

end.
