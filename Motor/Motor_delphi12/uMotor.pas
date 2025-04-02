unit uMotor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OverbyteIcsWndControl, OverbyteIcsWSocket;

type
  TForm1 = class(TForm)
    wSocket: TWSocket;
    pnlStatus: TPanel;
    Memo1: TMemo;
    btnConnect: TButton;
    btnDisconnect: TButton;
    btnSendCommand: TButton;
    btnExcite: TButton;
    btnStartMotor: TButton;
    btnStopMotor: TButton;
    btnRunContinue: TButton;
    btnStopContinue: TButton;
    btnStartZero: TButton;
    btnStopZero: TButton;
    btnEmergencyStop: TButton;
    btnSetPosition: TButton;
    btnSetSpeed: TButton;
    edtSetPosition: TEdit;
    edtSetSpeed: TEdit;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    procedure SendModbusQuery(const Data: array of Byte);
    procedure btnConnectClick(Sender: TObject);
    procedure wSocketSessionConnected(Sender: TObject; ErrCode: Word);
    procedure wSocketSessionClosed(Sender: TObject; ErrCode: Word);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnSendCommandClick(Sender: TObject);
    procedure wSocketDataAvailable(Sender: TObject; ErrCode: Word);
    procedure btnExciteClick(Sender: TObject);
    procedure btnSetPositionClick(Sender: TObject);
    procedure btnSetSpeedClick(Sender: TObject);
    procedure btnStartMotorClick(Sender: TObject);
    procedure btnStopMotorClick(Sender: TObject);
    procedure btnRunContinueClick(Sender: TObject);
    procedure btnStopContinueClick(Sender: TObject);
    procedure btnStartZeroClick(Sender: TObject);
    procedure btnStopZeroClick(Sender: TObject);
    procedure btnEmergencyStopClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  rcvData : string;
  ResponseBuffer : array of Byte;


implementation

function ModbusCRC16(const Data: array of Byte; Len: Integer): Word;
var
  crc: Word;
  i, j: Integer;
begin
  crc := $FFFF;
  for i := 0 to Len - 1 do
  begin
    crc := crc xor Data[i];
    for j := 0 to 7 do
    begin
      if (crc and 1) <> 0 then
        crc := (crc shr 1) xor $A001
      else
        crc := crc shr 1;
    end;
  end;
  Result := crc;
end;


procedure TForm1.SendModbusQuery(const Data: array of Byte);
var
  FullQuery: array[0..255] of Byte;
  i, len: Integer;
  crc: Word;
  logMsg: string;
begin

  len := Length(Data);

  // 1. 데이터 복사
  for i := 0 to len - 1 do
    FullQuery[i] := Data[i];

  // 2. CRC 계산 및 추가
  crc := ModbusCRC16(Data, len);
  FullQuery[len] := Lo(crc);        // CRC Low Byte
  FullQuery[len + 1] := Hi(crc);    // CRC High Byte

  // 3. 전송
  wSocket.Send(@FullQuery, len + 2);

  // 4. 로그 출력
  logMsg := '';
  for i := 0 to len + 1 do
    logMsg := logMsg + IntToHex(FullQuery[i], 2) + ' ';
  Memo1.Lines.Add('보냄: ' + TrimRight(logMsg));
end;

{$R *.dfm}

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  pnlStatus.Color := clBlue;
  pnlStatus.Font.Color := clBlack;
  pnlStatus.Caption := '연결시도중...';

  wSocket.Proto := 'tcp';
  wSocket.Addr := '192.168.127.254';
  wSocket.Port := '4001';
  wSocket.LineMode := False;
  wSocket.Connect;
end;

procedure TForm1.wSocketSessionConnected(Sender: TObject; ErrCode: Word);
begin
  if ErrCode = 0 then
  begin
    pnlStatus.Color := clLime;
    pnlStatus.Font.Color := clBlack;
    pnlStatus.Caption := '연결 완료';
  end
  else
  begin
    pnlStatus.Color := clRed;
    pnlStatus.Font.Color := clBlack;
    pnlStatus.Caption := '연결 실패';
  end;
end;

procedure TForm1.wSocketSessionClosed(Sender: TObject; ErrCode: Word);
begin
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;
  pnlStatus.Caption := '연결 끊어짐';
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  wSocket.Close;

  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;
  pnlStatus.Caption := '연결 해제됨';
end;

procedure TForm1.btnSendCommandClick(Sender: TObject);
var
  Query: array[0..7] of Byte;
begin
  if wSocket.State = wsConnected then
  begin
  //쿼리 구성 : 01, 03, 04, 02, 00, 04, E4, F9
  Query[0] := $01;
  Query[1] := $03;
  Query[2] := $04;
  Query[3] := $02;
  Query[4] := $00;
  Query[5] := $04;
  Query[6] := $E4;
  Query[7] := $F9;

  wSocket.Send(@Query, 8);
  end
  else
  begin
    ShowMessage('연결되지 않았습니다!');
    Exit;
  end;
end;

procedure TForm1.wSocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  Buffer: array[0..255] of Byte;
  Len, i: Integer;
  ExpectedLen: Integer;
  MsgStr: string;
begin
  Len := wSocket.Receive(@Buffer, SizeOf(Buffer));
  if Len <= 0 then Exit;

  SetLength(ResponseBuffer, Length(ResponseBuffer) + Len);
  for i := 0 to Len - 1 do
    ResponseBuffer[Length(ResponseBuffer) - Len + i] := Buffer[i];

  while True do
  begin
    if Length(ResponseBuffer) < 2 then Exit;

    case ResponseBuffer[1] of
      $03 : ExpectedLen := 13;
      $06 : ExpectedLen := 8;
      $10 : ExpectedLen := 8;
    else
      Exit;
    end;

    if Length(ResponseBuffer) < ExpectedLen then Exit;


    MsgStr := '';
    for i := 0 to ExpectedLen - 1 do
      MsgStr := MsgStr + IntToHex(ResponseBuffer[i], 2) + ' ';
    Memo1.Lines.Add('응답: ' + TrimRight(MsgStr));

    for i := 0 to Length(ResponseBuffer) - ExpectedLen - 1 do
      ResponseBuffer[i] := ResponseBuffer[i + ExpectedLen];
    SetLength(ResponseBuffer, Length(ResponseBuffer) - ExpectedLen);

  end;
end;

procedure TForm1.btnExciteClick(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $1E,
    $20, $00
  ]);
end;

procedure TForm1.btnSetPositionClick(Sender: TObject);
var
  stepValue: LongInt;
  highWord, lowWord: Word;
begin
  try
    stepValue := StrToInt(edtSetPosition.Text);
  except
    ShowMessage('숫자를 입력해주세요!');
    Exit;
  end;

  if (stepValue < 0) or (stepValue > 2147483647) then
  begin
    ShowMessage('0 ~ 2,147,483,647 범위만 가능합니다!');
    Exit;
  end;

  highWord := Word((LongWord(stepValue) shr 16) and $FFFF);
  lowWord  := Word(LongWord(stepValue) and $FFFF);

  SendModbusQuery
  ([
    $01,
    $10,
    $04,
    $02, $00,
    $02, $04,
    highWord shr 8, highWord and $FF,
    lowWord shr 8, lowWord and $FF
  ]);
end;

procedure TForm1.btnSetSpeedClick(Sender: TObject);
var
  speedValue: LongInt;
  highWord, lowWord: Word;
begin
  try
    speedValue := StrToInt(edtSetSpeed.Text);
  except
    ShowMessage('숫자를 정확히 입력해주세요!');
    Exit;
  end;

  if (speedValue < 0) or (speedValue > 2147483647) then
  begin
    ShowMessage('0 ~ 2,147,483,647 범위만 가능합니다!');
    Exit;
  end;

  highWord := Word((LongWord(speedValue) shr 16) and $FFFF);
  lowWord := Word(LongWord(speedValue) and $FFFF);

  SendModbusQuery
  ([
    $01,
    $10,
    $05, $02,
    $00, $02,
    $04,
    highWord shr 8, highWord and $FF,
    lowWord shr 8, lowWord and $FF
  ]);
end;



procedure TForm1.btnStartMotorClick(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $1E,
    $21, $01
  ]);
end;

procedure TForm1.btnStopMotorClick(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $1E,
    $20, $01
  ]);
end;

procedure TForm1.btnRunContinueClick(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $1E,
    $22, $01
  ]);
end;

procedure TForm1.btnStopContinueClick(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $1E,
    $20, $01
  ]);
end;

procedure TForm1.btnStartZeroClick(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $1E,
    $28, $00
  ]);
end;

procedure TForm1.btnStopZeroClick(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $1E,
    $20, $00
  ]);
end;

procedure TForm1.btnEmergencyStopClick(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $1E,
    $00, $00
  ]);
end;

end.
