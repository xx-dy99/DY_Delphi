unit uMotor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OverbyteIcsWndControl, OverbyteIcsWSocket, Math, System.StrUtils;

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
    btnRunRvs: TButton;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    GroupBox1: TGroupBox;
    pnl1_M0: TPanel;
    pnl1_M2: TPanel;
    pnl1_M5: TPanel;
    pnl1_ALM: TPanel;
    pnl1_M3: TPanel;
    pnl1_WNG: TPanel;
    pnl1_M4: TPanel;
    pnl1_M1: TPanel;
    Panel19: TPanel;
    pnl3_M0: TPanel;
    pnl3_M2: TPanel;
    pnl3_M5: TPanel;
    pnl3_ZSG: TPanel;
    pnl3_M3: TPanel;
    pnl3_TIM: TPanel;
    pnl3_M4: TPanel;
    pnl3_M1: TPanel;
    Panel28: TPanel;
    Panel47: TPanel;
    Panel48: TPanel;
    Panel49: TPanel;
    Panel50: TPanel;
    Panel51: TPanel;
    Panel52: TPanel;
    Panel53: TPanel;
    Panel54: TPanel;
    Panel55: TPanel;
    pnl2_SBSY: TPanel;
    pnl2_OH: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    pnl2_TIM: TPanel;
    Panel34: TPanel;
    pnl2_ZSG: TPanel;
    pnl2_ENABLE: TPanel;
    Panel37: TPanel;
    pnl3_ALMCD: TPanel;
    Panel46: TPanel;
    pnl3_WNG: TPanel;
    pnl3_PLS: TPanel;
    pnl3_HOMES: TPanel;
    pnl3_START: TPanel;
    pnl3_MLS: TPanel;
    pnl3_OH: TPanel;
    pnl3_SLIT: TPanel;
    pnl3_STEPOUT: TPanel;
    Panel64: TPanel;
    pnl3_MOVE: TPanel;
    pnl3_HOME: TPanel;
    pnl3_AREA: TPanel;
    pnl3_ENABLE: TPanel;
    pnl3_READY: TPanel;
    pnl3_ALM: TPanel;
    pnl3_SBSY: TPanel;
    pnl3_0: TPanel;
    Panel73: TPanel;
    pnl1_START: TPanel;
    pnl1_MOVE: TPanel;
    pnl1_READY: TPanel;
    pnl1_AREA: TPanel;
    pnl1_HOME: TPanel;
    Panel79: TPanel;
    Panel80: TPanel;
    pnl1_STEPOUT: TPanel;
    Panel82: TPanel;
    Panel83: TPanel;
    Panel84: TPanel;
    Panel85: TPanel;
    Panel86: TPanel;
    Panel87: TPanel;
    Panel88: TPanel;
    Panel89: TPanel;
    Panel90: TPanel;
    Panel91: TPanel;
    Panel92: TPanel;
    Panel93: TPanel;
    Panel94: TPanel;
    Panel95: TPanel;
    Panel96: TPanel;
    Panel97: TPanel;
    Panel98: TPanel;
    Panel99: TPanel;
    Panel100: TPanel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    TimerStatusCheck: TTimer;
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
    procedure btnRunRvsClick(Sender: TObject);
    procedure TimerStatusCheckTimer(Sender: TObject);

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

//CRC 계산하는 함수  (const를 쓰는 이유 , 변하지않는 틀의 함수?)
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

//이제 앞으로 공통적으로 모든 신호처리를 하는 프로시저
//순서대로 번호만 넣을수있게 배열
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

  // 2. CRC 계산 및 추가 (CRC계산함수를 여기서 사용함)
  crc := ModbusCRC16(Data, len);
  FullQuery[len] := Lo(crc);        // CRC Low Byte
  FullQuery[len + 1] := Hi(crc);    // CRC High Byte

  // 3. 전송
  wSocket.Send(@FullQuery, len + 2);

  // 4. 로그 출력 (로그에 보냄 부분)
  logMsg := '';
  for i := 0 to len + 1 do
    logMsg := logMsg + IntToHex(FullQuery[i], 2) + ' ';
  Memo1.Lines.Add('보냄: ' + TrimRight(logMsg));
end;


{$R *.dfm} //이위에 선언하는 이유는 잘모름

//연결버튼 클릭해서 ip주소와 포트를 연결
procedure TForm1.btnConnectClick(Sender: TObject);
begin
  pnlStatus.ParentBackground := False; //델파이5에서 12로 넘어갈떄 패널 색 변경할려면 사용
  pnlStatus.Color := clBlue;
  pnlStatus.Font.Color := clBlack;
  pnlStatus.Caption := '연결시도중...';

  wSocket.Proto := 'tcp';
  wSocket.Addr := '192.168.127.254';
  wSocket.Port := '4001';
  wSocket.LineMode := False;
  wSocket.Connect;
end;

//wSocket연결됐을때 패널상태변화 (연결버튼클릭후 바로 이어짐)
procedure TForm1.wSocketSessionConnected(Sender: TObject; ErrCode: Word);
begin
  if ErrCode = 0 then
  begin
    pnlStatus.ParentBackground := False;
    pnlStatus.Color := clLime;
    pnlStatus.Font.Color := clBlack;
    pnlStatus.Caption := '연결 완료';
    TimerStatusCheck.Enabled := True; //타이머 작동
  end
  else
  begin
    pnlStatus.ParentBackground := False;
    pnlStatus.Color := clRed;
    pnlStatus.Font.Color := clBlack;
    pnlStatus.Caption := '연결 실패';
  end;
end;

//연결해제 버튼 누름 wSocket과 연결해제 이벤트
procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  wSocket.Close;
  TimerStatusCheck.Enabled := False; //타이머 해제

  pnlStatus.ParentBackground := False;
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;
  pnlStatus.Caption := '연결 해제됨';
end;

//연결 해제버튼 누름과 연결해제시 이벤트
procedure TForm1.wSocketSessionClosed(Sender: TObject; ErrCode: Word);
begin
  pnlStatus.ParentBackground := False;
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;
  pnlStatus.Caption := '연결 끊어짐';
end;

//명령전송버튼 클릭(테스트용)
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

//중요!!!!!!!!!!!!!!!!wSocket에서 데이터 처리 프로시저
procedure TForm1.wSocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  Buffer: array[0..255] of Byte; //버퍼를 배열로 선언
  Len, i: Integer;
  MsgStr: string;
  ByteCount: Integer;
  ExpectedLen: Integer;
begin
  Len := wSocket.Receive(@Buffer, SizeOf(Buffer));//@Buffer, sizeof(buffer) -> 'Buffer라는 배열 시작 주소로부터 256바이트 크기만큼 데이터를 수신해줘' 라는 뜻
  if Len <= 0 then Exit;

  SetLength(ResponseBuffer, Length(ResponseBuffer) + Len);
  for i := 0 to Len - 1 do
    ResponseBuffer[Length(ResponseBuffer) - Len + i] := Buffer[i];

  while Length(ResponseBuffer) >= 5 do // 최소 응답
  begin
    case ResponseBuffer[1] of  //Funtion코드를 케이스로 분리
      $03: //3일때
        begin
          ByteCount := ResponseBuffer[2];
          ExpectedLen := 3 + ByteCount + 2;
        end;

      $06, $10: //6이나 10일때
        begin
          ExpectedLen := 8;
        end;

    else
      begin
        // 알 수 없는 FunctionCode → 첫 바이트 제거
        Delete(ResponseBuffer, 0, 1);
        Continue;
      end;
    end;

    if Length(ResponseBuffer) < ExpectedLen then
      Exit;

    // 로그 출력, 로그출력 부분에서 응답 나오는 부분
    MsgStr := '';
    for i := 0 to ExpectedLen - 1 do
      MsgStr := MsgStr + IntToHex(ResponseBuffer[i], 2) + ' ';
    Memo1.Lines.Add('응답: ' + TrimRight(MsgStr));

    // 상태 처리 (예: $03 상태 1/2 처리 코드 여기에 삽입)
    if (ResponseBuffer[1] = $03) and (ResponseBuffer[2] = $04) then
    begin
      // 상태1 + 상태2 처리 가능
      var
      HighByte, LowByte, State2Byte: Byte;
      HighByte := ResponseBuffer[3];
      LowByte := ResponseBuffer[4];
      State2Byte := ResponseBuffer[6];

      // 패널 색상 처리
      pnl1_START.Color := IfThen((HighByte and $01) <> 0, clLime, clBtnFace);
      pnl1_STEPOUT.Color := IfThen((HighByte and $02) <> 0, clRed, clBtnFace);
      pnl1_MOVE.Color := IfThen((HighByte and $04) <> 0, clLime, clBtnFace);
      pnl1_HOME.Color := IfThen((HighByte and $08) <> 0, clLime, clBtnFace);
      pnl1_READY.Color := IfThen((HighByte and $20) <> 0, clLime, clBtnFace);
      pnl1_AREA.Color := IfThen((HighByte and $80) <> 0, clLime, clBtnFace);

      pnl1_M0.Color := IfThen((LowByte and $01) <> 0, clLime, clBtnFace);
      pnl1_M1.Color := IfThen((LowByte and $02) <> 0, clLime, clBtnFace);
      pnl1_M2.Color := IfThen((LowByte and $04) <> 0, clLime, clBtnFace);
      pnl1_M3.Color := IfThen((LowByte and $08) <> 0, clLime, clBtnFace);
      pnl1_M4.Color := IfThen((LowByte and $10) <> 0, clLime, clBtnFace);
      pnl1_M5.Color := IfThen((LowByte and $20) <> 0, clLime, clBtnFace);
      pnl1_WNG.Color := IfThen((LowByte and $40) <> 0, clRed, clBtnFace);
      pnl1_ALM.Color := IfThen((LowByte and $80) <> 0, clRed, clBtnFace);

      pnl2_SBSY.Color := IfThen((State2Byte and $01) <> 0, clLime, clBtnFace);
      pnl2_ENABLE.Color := IfThen((State2Byte and $02) <> 0, clLime, clBtnFace);
      pnl2_OH.Color := IfThen((State2Byte and $04) <> 0, clRed, clBtnFace);
      pnl2_TIM.Color := IfThen((State2Byte and $08) <> 0, clLime, clBtnFace);
      pnl2_ZSG.Color := IfThen((State2Byte and $10) <> 0, clLime, clBtnFace);
    end;

    if (ResponseBuffer[1] = $03) and (ResponseBuffer[2] = $04) then
    begin
      var
      HighByte1, LowByte1, HighByte2, LowByte2: Byte;
      HighByte1 := ResponseBuffer[3];
      LowByte1 := ResponseBuffer[4];
      HighByte2 := ResponseBuffer[5];
      LowByte2 := ResponseBuffer[6];

      pnl3_ALMCD.Color := IfThen((HighByte1) <> 0, clLime, clBtnFace);
      pnl3_ALMCD.Caption := IfThen((HighByte1) <> 0, 'ALMCD ON', 'ALMCD OFF');

      pnl3_M0.Color := IfThen((LowByte1 and $01) <> 0, clLime, clBtnFace);
      pnl3_M1.Color := IfThen((LowByte1 and $02) <> 0, clLime, clBtnFace);
      pnl3_M2.Color := IfThen((LowByte1 and $04) <> 0, clLime, clBtnFace);
      pnl3_M3.Color := IfThen((LowByte1 and $08) <> 0, clLime, clBtnFace);
      pnl3_M4.Color := IfThen((LowByte1 and $10) <> 0, clLime, clBtnFace);
      pnl3_M5.Color := IfThen((LowByte1 and $20) <> 0, clLime, clBtnFace);
      pnl3_TIM.Color := IfThen((LowByte1 and $40) <> 0, clLime, clBtnFace);
      pnl3_TIM.Caption := IfThen((LowByte1 and $40) <> 0, 'TIM검출중', 'TIM검출없음');
      pnl3_ZSG.Color := IfThen((LowByte1 and $80) <> 0, clLime, clBtnFace);
      pnl3_ZSG.Caption := IfThen((LowByte1 and $80) <> 0, 'Z검출중', 'Z검출없음');

      pnl3_WNG.Color := IfThen((HighByte2 and $01) <> 0, clRed, clBtnFace);
      pnl3_WNG.Caption := IfThen((HighByte2 and $01) <> 0, 'WARNING', 'SAFE');
      pnl3_STEPOUT.Color := IfThen((HighByte2 and $02) <> 0, clLime, clBtnFace);
      pnl3_STEPOUT.Caption := IfThen((HighByte2 and $02) <> 0, '편차이상발생', '편차이상없음');
      pnl3_PLS.Color := IfThen((HighByte2 and $04) <> 0, clLime, clBtnFace);
      pnl3_PLS.Caption := IfThen((HighByte2 and $04) <> 0, 'LS+ ON', 'LS+ OFF');
      pnl3_MLS.Color := IfThen((HighByte2 and $08) <> 0, clLime, clBtnFace);
      pnl3_MLS.Caption := IfThen((HighByte2 and $08) <> 0, 'LS- ON', 'LS- OFF');
      pnl3_SLIT.Color := IfThen((HighByte2 and $10) <> 0, clLime, clBtnFace);
      pnl3_SLIT.Caption := IfThen((HighByte2 and $10) <> 0, 'SLIT ON', 'SLIT OFF');
      pnl3_HOMES.Color := IfThen((HighByte2 and $20) <> 0, clLime, clBtnFace);
      pnl3_HOMES.Caption := IfThen((HighByte2 and $20) <> 0, 'HOMES ON', 'HOMES OFF');
      pnl3_OH.Color := IfThen((HighByte2 and $40) <> 0, clRed, clBtnFace);
      pnl3_OH.Caption := IfThen((HighByte2 and $40) <> 0, '과열WNG', '과열없음');
      pnl3_START.Color := IfThen((HighByte2 and $80) <> 0, clLime, clBtnFace);
      pnl3_START.Caption := IfThen((HighByte2 and $80) <> 0, 'START', 'STOP');

      pnl3_MOVE.Color := IfThen((LowByte2 and $01) <> 0, clLime, clBtnFace);
      pnl3_MOVE.Caption := IfThen((LowByte2 and $01) <> 0, '운전중', '정지중');
      pnl3_0.Color := IfThen((LowByte2 and $02) <> 0, clLime, clBtnFace);
      pnl3_HOME.Color := IfThen((LowByte2 and $04) <> 0, clLime, clBtnFace);
      pnl3_HOME.Caption := IfThen((LowByte2 and $04) <> 0, 'Motor원점', 'Motor원점X');
      pnl3_READY.Color := IfThen((LowByte2 and $08) <> 0, clLime, clBtnFace);
      pnl3_READY.Caption := IfThen((LowByte2 and $08) <> 0, '운전준비완료', '운전불가');
      pnl3_SBSY.Color := IfThen((LowByte2 and $10) <> 0, clLime, clBtnFace);
      pnl3_SBSY.Caption := IfThen((LowByte2 and $10) <> 0, '내부처리중', '내부처리X');
      pnl3_AREA.Color := IfThen((LowByte2 and $20) <> 0, clLime, clBtnFace);
      pnl3_AREA.Caption := IfThen((LowByte2 and $20) <> 0, 'AREA범위안', 'AREA범위밖');
      pnl3_ALM.Color := IfThen((LowByte2 and $40) <> 0, clRed, clBtnFace);
      pnl3_ALM.Caption := IfThen((LowByte2 and $40) <> 0, 'ALM발생중', 'ALM없음');
      pnl3_ENABLE.Color := IfThen((LowByte2 and $80) <> 0, clLime, clBtnFace);
      pnl3_ENABLE.Caption := IfThen((LowByte2 and $80) <> 0, 'ENABLE', 'DISABLE');
    end;

    // 처리한 응답 제거
    Delete(ResponseBuffer, 0, ExpectedLen);
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

procedure TForm1.btnRunRvsClick(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $1E,
    $24, $01
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

procedure TForm1.TimerStatusCheckTimer(Sender: TObject);
begin
  SendModbusQuery // 상태 1,2 를 한번에 이어서 진행
  ([
    $01,
    $03,
    $00, $20,
    $00, $02
  ]);
end;

end.
