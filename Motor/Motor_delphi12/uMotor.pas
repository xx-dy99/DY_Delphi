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

//CRC ����ϴ� �Լ�  (const�� ���� ���� , �������ʴ� Ʋ�� �Լ�?)
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

//���� ������ ���������� ��� ��ȣó���� �ϴ� ���ν���
//������� ��ȣ�� �������ְ� �迭
procedure TForm1.SendModbusQuery(const Data: array of Byte);
var
  FullQuery: array[0..255] of Byte;
  i, len: Integer;
  crc: Word;
  logMsg: string;
begin

  len := Length(Data);

  // 1. ������ ����
  for i := 0 to len - 1 do
    FullQuery[i] := Data[i];

  // 2. CRC ��� �� �߰� (CRC����Լ��� ���⼭ �����)
  crc := ModbusCRC16(Data, len);
  FullQuery[len] := Lo(crc);        // CRC Low Byte
  FullQuery[len + 1] := Hi(crc);    // CRC High Byte

  // 3. ����
  wSocket.Send(@FullQuery, len + 2);

  // 4. �α� ��� (�α׿� ���� �κ�)
  logMsg := '';
  for i := 0 to len + 1 do
    logMsg := logMsg + IntToHex(FullQuery[i], 2) + ' ';
  Memo1.Lines.Add('����: ' + TrimRight(logMsg));
end;


{$R *.dfm} //������ �����ϴ� ������ �߸�

//�����ư Ŭ���ؼ� ip�ּҿ� ��Ʈ�� ����
procedure TForm1.btnConnectClick(Sender: TObject);
begin
  pnlStatus.ParentBackground := False; //������5���� 12�� �Ѿ�� �г� �� �����ҷ��� ���
  pnlStatus.Color := clBlue;
  pnlStatus.Font.Color := clBlack;
  pnlStatus.Caption := '����õ���...';

  wSocket.Proto := 'tcp';
  wSocket.Addr := '192.168.127.254';
  wSocket.Port := '4001';
  wSocket.LineMode := False;
  wSocket.Connect;
end;

//wSocket��������� �гλ��º�ȭ (�����ưŬ���� �ٷ� �̾���)
procedure TForm1.wSocketSessionConnected(Sender: TObject; ErrCode: Word);
begin
  if ErrCode = 0 then
  begin
    pnlStatus.ParentBackground := False;
    pnlStatus.Color := clLime;
    pnlStatus.Font.Color := clBlack;
    pnlStatus.Caption := '���� �Ϸ�';
    TimerStatusCheck.Enabled := True; //Ÿ�̸� �۵�
  end
  else
  begin
    pnlStatus.ParentBackground := False;
    pnlStatus.Color := clRed;
    pnlStatus.Font.Color := clBlack;
    pnlStatus.Caption := '���� ����';
  end;
end;

//�������� ��ư ���� wSocket�� �������� �̺�Ʈ
procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  wSocket.Close;
  TimerStatusCheck.Enabled := False; //Ÿ�̸� ����

  pnlStatus.ParentBackground := False;
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;
  pnlStatus.Caption := '���� ������';
end;

//���� ������ư ������ ���������� �̺�Ʈ
procedure TForm1.wSocketSessionClosed(Sender: TObject; ErrCode: Word);
begin
  pnlStatus.ParentBackground := False;
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;
  pnlStatus.Caption := '���� ������';
end;

//������۹�ư Ŭ��(�׽�Ʈ��)
procedure TForm1.btnSendCommandClick(Sender: TObject);
var
  Query: array[0..7] of Byte;
begin
  if wSocket.State = wsConnected then
  begin
  //���� ���� : 01, 03, 04, 02, 00, 04, E4, F9
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
    ShowMessage('������� �ʾҽ��ϴ�!');
    Exit;
  end;
end;

//�߿�!!!!!!!!!!!!!!!!wSocket���� ������ ó�� ���ν���
procedure TForm1.wSocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  Buffer: array[0..255] of Byte; //���۸� �迭�� ����
  Len, i: Integer;
  MsgStr: string;
  ByteCount: Integer;
  ExpectedLen: Integer;
begin
  Len := wSocket.Receive(@Buffer, SizeOf(Buffer));//@Buffer, sizeof(buffer) -> 'Buffer��� �迭 ���� �ּҷκ��� 256����Ʈ ũ�⸸ŭ �����͸� ��������' ��� ��
  if Len <= 0 then Exit;

  SetLength(ResponseBuffer, Length(ResponseBuffer) + Len);
  for i := 0 to Len - 1 do
    ResponseBuffer[Length(ResponseBuffer) - Len + i] := Buffer[i];

  while Length(ResponseBuffer) >= 5 do // �ּ� ����
  begin
    case ResponseBuffer[1] of  //Funtion�ڵ带 ���̽��� �и�
      $03: //3�϶�
        begin
          ByteCount := ResponseBuffer[2];
          ExpectedLen := 3 + ByteCount + 2;
        end;

      $06, $10: //6�̳� 10�϶�
        begin
          ExpectedLen := 8;
        end;

    else
      begin
        // �� �� ���� FunctionCode �� ù ����Ʈ ����
        Delete(ResponseBuffer, 0, 1);
        Continue;
      end;
    end;

    if Length(ResponseBuffer) < ExpectedLen then
      Exit;

    // �α� ���, �α���� �κп��� ���� ������ �κ�
    MsgStr := '';
    for i := 0 to ExpectedLen - 1 do
      MsgStr := MsgStr + IntToHex(ResponseBuffer[i], 2) + ' ';
    Memo1.Lines.Add('����: ' + TrimRight(MsgStr));

    // ���� ó�� (��: $03 ���� 1/2 ó�� �ڵ� ���⿡ ����)
    if (ResponseBuffer[1] = $03) and (ResponseBuffer[2] = $04) then
    begin
      // ����1 + ����2 ó�� ����
      var
      HighByte, LowByte, State2Byte: Byte;
      HighByte := ResponseBuffer[3];
      LowByte := ResponseBuffer[4];
      State2Byte := ResponseBuffer[6];

      // �г� ���� ó��
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
      pnl3_TIM.Caption := IfThen((LowByte1 and $40) <> 0, 'TIM������', 'TIM�������');
      pnl3_ZSG.Color := IfThen((LowByte1 and $80) <> 0, clLime, clBtnFace);
      pnl3_ZSG.Caption := IfThen((LowByte1 and $80) <> 0, 'Z������', 'Z�������');

      pnl3_WNG.Color := IfThen((HighByte2 and $01) <> 0, clRed, clBtnFace);
      pnl3_WNG.Caption := IfThen((HighByte2 and $01) <> 0, 'WARNING', 'SAFE');
      pnl3_STEPOUT.Color := IfThen((HighByte2 and $02) <> 0, clLime, clBtnFace);
      pnl3_STEPOUT.Caption := IfThen((HighByte2 and $02) <> 0, '�����̻�߻�', '�����̻����');
      pnl3_PLS.Color := IfThen((HighByte2 and $04) <> 0, clLime, clBtnFace);
      pnl3_PLS.Caption := IfThen((HighByte2 and $04) <> 0, 'LS+ ON', 'LS+ OFF');
      pnl3_MLS.Color := IfThen((HighByte2 and $08) <> 0, clLime, clBtnFace);
      pnl3_MLS.Caption := IfThen((HighByte2 and $08) <> 0, 'LS- ON', 'LS- OFF');
      pnl3_SLIT.Color := IfThen((HighByte2 and $10) <> 0, clLime, clBtnFace);
      pnl3_SLIT.Caption := IfThen((HighByte2 and $10) <> 0, 'SLIT ON', 'SLIT OFF');
      pnl3_HOMES.Color := IfThen((HighByte2 and $20) <> 0, clLime, clBtnFace);
      pnl3_HOMES.Caption := IfThen((HighByte2 and $20) <> 0, 'HOMES ON', 'HOMES OFF');
      pnl3_OH.Color := IfThen((HighByte2 and $40) <> 0, clRed, clBtnFace);
      pnl3_OH.Caption := IfThen((HighByte2 and $40) <> 0, '����WNG', '��������');
      pnl3_START.Color := IfThen((HighByte2 and $80) <> 0, clLime, clBtnFace);
      pnl3_START.Caption := IfThen((HighByte2 and $80) <> 0, 'START', 'STOP');

      pnl3_MOVE.Color := IfThen((LowByte2 and $01) <> 0, clLime, clBtnFace);
      pnl3_MOVE.Caption := IfThen((LowByte2 and $01) <> 0, '������', '������');
      pnl3_0.Color := IfThen((LowByte2 and $02) <> 0, clLime, clBtnFace);
      pnl3_HOME.Color := IfThen((LowByte2 and $04) <> 0, clLime, clBtnFace);
      pnl3_HOME.Caption := IfThen((LowByte2 and $04) <> 0, 'Motor����', 'Motor����X');
      pnl3_READY.Color := IfThen((LowByte2 and $08) <> 0, clLime, clBtnFace);
      pnl3_READY.Caption := IfThen((LowByte2 and $08) <> 0, '�����غ�Ϸ�', '�����Ұ�');
      pnl3_SBSY.Color := IfThen((LowByte2 and $10) <> 0, clLime, clBtnFace);
      pnl3_SBSY.Caption := IfThen((LowByte2 and $10) <> 0, '����ó����', '����ó��X');
      pnl3_AREA.Color := IfThen((LowByte2 and $20) <> 0, clLime, clBtnFace);
      pnl3_AREA.Caption := IfThen((LowByte2 and $20) <> 0, 'AREA������', 'AREA������');
      pnl3_ALM.Color := IfThen((LowByte2 and $40) <> 0, clRed, clBtnFace);
      pnl3_ALM.Caption := IfThen((LowByte2 and $40) <> 0, 'ALM�߻���', 'ALM����');
      pnl3_ENABLE.Color := IfThen((LowByte2 and $80) <> 0, clLime, clBtnFace);
      pnl3_ENABLE.Caption := IfThen((LowByte2 and $80) <> 0, 'ENABLE', 'DISABLE');
    end;

    // ó���� ���� ����
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
    ShowMessage('���ڸ� �Է����ּ���!');
    Exit;
  end;

  if (stepValue < 0) or (stepValue > 2147483647) then
  begin
    ShowMessage('0 ~ 2,147,483,647 ������ �����մϴ�!');
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
    ShowMessage('���ڸ� ��Ȯ�� �Է����ּ���!');
    Exit;
  end;

  if (speedValue < 0) or (speedValue > 2147483647) then
  begin
    ShowMessage('0 ~ 2,147,483,647 ������ �����մϴ�!');
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
  SendModbusQuery // ���� 1,2 �� �ѹ��� �̾ ����
  ([
    $01,
    $03,
    $00, $20,
    $00, $02
  ]);
end;

end.
