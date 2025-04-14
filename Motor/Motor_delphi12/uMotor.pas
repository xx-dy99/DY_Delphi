unit uMotor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OverbyteIcsWndControl, OverbyteIcsWSocket, Math, System.StrUtils, Vcl.Buttons,
  Vcl.Samples.Spin, Vcl.ComCtrls;

type
  TStatusStep = (psState1And2, psDriverStatus, psStepPosition, psSpeedStatus, psSpeedInfo);

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
    Panel1: TPanel;
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
    TimerStatus: TTimer;
    pnlCurrentStep: TPanel;
    Button1: TButton;
    pnlCurrentSpeed: TPanel;
    Panel12: TPanel;
    btnSetPosition: TBitBtn;
    btnSetSpeed: TBitBtn;
    btnSpeedUp: TBitBtn;
    btnSpeedDown: TBitBtn;
    spnSetPosition: TSpinEdit;
    spnSetSpeed: TSpinEdit;
    spnSpeedUp: TSpinEdit;
    spnSpeedDown: TSpinEdit;
    pnlSpeedUp: TPanel;
    pnlSpeedDown: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    btnPreset: TButton;
    StatusBar1: TStatusBar;
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
    procedure TimerStatusTimer(Sender: TObject);
    procedure btnSpeedUpClick(Sender: TObject);
    procedure btnSpeedDownClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnPresetClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  rcvData : string;
  ResponseBuffer : array of Byte;
  WaitingForReply : Boolean = False; //Ÿ�̸� ���� ��ٷ��ֱ�
  CurrentStep : TStatusStep = psState1And2; // Ÿ�̸� status (?)
  TargetStepPosition: LongInt = 0; // step�̵��� step�������� ��ư�� �����ϴ� ����� ���� ����  (nil)<-�̺�Ʈ �����̾����� �������� �����Ŵ

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
  //+�߰� Ÿ�̸ӿ� �̺�Ʈ��ư�� �浹�����ʴ� �ڵ�
  if WaitingForReply then
  begin
    //Memo1.Lines.Add('������̹Ƿ� ���� ��ҵ�');
    Exit;
  end;

  WaitingForReply := True;
  TimerStatus.Enabled := False;

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
    TimerStatus.Enabled := True; //Ÿ�̸� �۵�

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
  TimerStatus.Enabled := False; //Ÿ�̸� ����


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

//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѿ����� �۵��κФѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�

//�߿�!!!!!!!!!!!!!!!!wSocket���� ������ ó�� ���ν���
procedure TForm1.wSocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  Buffer: array[0..255] of Byte;
  Len, i: Integer;
  MsgStr: string;
  ByteCount: Integer;
  ExpectedLen: Integer;
begin
  Len := wSocket.Receive(@Buffer, SizeOf(Buffer));
  if Len <= 0 then Exit;

  SetLength(ResponseBuffer, Length(ResponseBuffer) + Len);
  for i := 0 to Len - 1 do
    ResponseBuffer[Length(ResponseBuffer) - Len + i] := Buffer[i];

  while Length(ResponseBuffer) >= 5 do  //function�ڵ忡 ���� ���� case ���� $03, $06, $10
  begin
    case ResponseBuffer[1] of
      $03:
        begin
          ByteCount := ResponseBuffer[2];
          ExpectedLen := 3 + ByteCount + 2;
        end;
      $06, $10:
        ExpectedLen := 8;
    else
      Delete(ResponseBuffer, 0, 1);
      Continue;
    end;

    if Length(ResponseBuffer) < ExpectedLen then Exit;

    MsgStr := '';
    for i := 0 to ExpectedLen - 1 do
      MsgStr := MsgStr + IntToHex(ResponseBuffer[i], 2) + ' ';
    Memo1.Lines.Add('����: ' + TrimRight(MsgStr)); //����޾ƿ��� �κ�(�α�ǥ��)

//�ѤѤѤѤѻ��¹� ǥ���ϴ� �κ� (Ÿ�̸ӿ� �׳� �����Ұ�� ���ý���Ǽ� ���� �����ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�

    //���¹� 1,2 ǥ��
    if (CurrentStep = psState1And2) and
       (ResponseBuffer[1] = $03) and (ResponseBuffer[2] = $04) then
    begin
      var HighByte, LowByte, State2Byte: Byte;
      HighByte := ResponseBuffer[3];
      LowByte := ResponseBuffer[4];
      State2Byte := ResponseBuffer[6];

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

    //drive ���� ǥ��
    if (CurrentStep = psDriverStatus) and
       (ResponseBuffer[1] = $03) and (ResponseBuffer[2] = $04) then
    begin
      var HighByte1, LowByte1, HighByte2, LowByte2: Byte;
      HighByte1 := ResponseBuffer[3];
      LowByte1 := ResponseBuffer[4];
      HighByte2 := ResponseBuffer[5];
      LowByte2 := ResponseBuffer[6];

      pnl3_ALMCD.Color := IfThen((HighByte1) <> 0, clRed, clBtnFace);
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

    //�гο� �ǽð� step��ġ ǥ��
    if (CurrentStep = psStepPosition) and
       (ResponseBuffer[1] = $03) and (ResponseBuffer[2] = $04) and (Length(ResponseBuffer) >= 9) then
    begin
      var posHiHi := ResponseBuffer[3];
      var posHiLo := ResponseBuffer[4];
      var posLoHi := ResponseBuffer[5];
      var posLoLo := ResponseBuffer[6];

      var position: LongInt;
      position := (posHiHi shl 24) or (posHiLo shl 16) or (posLoHi shl 8) or posLoLo;

      if (position and $80000000) <> 0 then
        position := LongInt(LongWord(position));

      pnlCurrentStep.Caption := IntToStr(position);

      if TargetStepPosition = position then
      begin
        btnStopMotorClick(nil);
      end;
    end;

    //�гο� �ǽð� �ӵ� ǥ��
    if (CurrentStep = psSpeedStatus) and
       (ResponseBuffer[1] = $03) and (ResponseBuffer[2] = $02) then
    begin
      var speedHi := ResponseBuffer[3];
      var speedLo := ResponseBuffer[4];
      var speed := (speedHi shl 8) or speedLo;

      pnlCurrentSpeed.Caption := IntToStr(speed) + 'Hz';
    end;

    //�гο� ����, ���� ǥ��
    if (ResponseBuffer[1] = $03) and (ResponseBuffer[2] = $08) then
    begin
      var AccHi := ResponseBuffer[3];
      var AccLo := ResponseBuffer[4];
      var DecHi := ResponseBuffer[5];
      var DecLo := ResponseBuffer[6];

      var acc := (AccHi shl 8) or AccLo;
      var dec := (DecHi shl 8) or DecLo;

      pnlSpeedUp.Caption := IntToStr(acc);
      pnlSpeedDown.Caption := IntToStr(dec);
    end;

    WaitingForReply := False;
    TimerStatus.Enabled := True;

    //Ÿ�̸Ӿ��� �������
    case CurrentStep of
      psState1And2:   CurrentStep := psDriverStatus;
      psDriverStatus: CurrentStep := psStepPosition;
      psStepPosition: CurrentStep := psSpeedStatus;
      psSpeedStatus:  CurrentStep := psSpeedInfo;
      psSpeedInfo:    CurrentStep := psState1And2;
    end;

    Delete(ResponseBuffer, 0, ExpectedLen);
  end;
end;

//C - ON��ư Ŭ�� (���� ON)
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

//��ġ���� ��ư(1000�⺻)
procedure TForm1.btnSetPositionClick(Sender: TObject);
var
  stepValue: LongInt;
  highWord, lowWord: Word;
begin
  try
    stepValue := spnSetPosition.Value;
  except
    ShowMessage('���ڸ� �Է����ּ���!');
    Exit;
  end;

  if (stepValue < 0) or (stepValue > 2147483647) then
  begin
    ShowMessage('0 ~ 2,147,483,647 ������ �����մϴ�!');
    Exit;
  end;

  TargetStepPosition := stepValue;

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

//���ͽ��ǵ� ���� ��ư
procedure TForm1.btnSetSpeedClick(Sender: TObject);
var
  speedValue: LongInt;
  highWord, lowWord: Word;
begin
  try
    speedValue := spnSetSpeed.Value;
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

//���� ��ư
procedure TForm1.btnSpeedUpClick(Sender: TObject);
var
  rate: Word;
begin
  rate := spnSpeedUp.Value;

  SendModbusQuery
  ([
    $01,
    $10,
    $02, $24,
    $00, $02,
    $04,
    Hi(rate shr 8), Lo(rate shr 8),
    Hi(rate), Lo(rate)
  ]);
end;

//���ӹ�ư
procedure TForm1.btnSpeedDownClick(Sender: TObject);
var
  rate: Word;
begin
  rate := spnSpeedDown.Value;

  SendModbusQuery
  ([
    $01,
    $10,
    $02, $26,
    $00, $02,
    $04,
    Hi(rate shr 8), Lo(rate shr 8),
    Hi(rate), Lo(rate)
  ]);
end;

//���͸� ����ó����ġ�� ���ߴ� ��ư
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

//���� ���� �̵� ��ư ���� ��ư
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

//step�� ������ġ�� 0���� ������ִ� ��ư
procedure TForm1.btnPresetClick(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $48,
    $00, $01
  ]);

  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(100);
      TThread.Synchronize(nil,
        procedure
        begin
            SendModbusQuery([
              $01, $06,
              $00, $48,
              $00, $00
            ]);
        end
       );
    end
  ).Start;
end;

//FWD ���Ͱ� ���������� �����̰� �ϴ� ��ư
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

//RVS ���Ͱ� ���������� �����̰� �ϴ� ��ư
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

//FWD, RVS�� �����ϰ� �ϴ� ��ư (RunStop)
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

//���� ���� �̵� ��ư (HOME)
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

//���� �����̵� ���� ��ư
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

//��ü ���� ����(STOP)
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

//�ʴ� ���¸� ��� �о�������� Ÿ�̸�
procedure TForm1.TimerStatusTimer(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'STEP:' + IntToStr(ord(CurrentStep));

  if WaitingForReply then Exit;

  case CurrentStep of
    psState1And2://���� 1,2 �� �ѹ��� �̾ ����
      begin
        StatusBar1.Panels[1].Text := '����1,2ǥ��';
        SendModbusQuery
        ([
          $01,
          $03,
          $00, $20,
          $00, $02
        ]);
        WaitingForReply := True;
      end;

    psDriverStatus: //����̹� ���¸� ǥ��
      begin
        StatusBar1.Panels[1].Text := '����̹� ���� ǥ��';
        SendModbusQuery
        ([
          $01,
          $03,
          $01, $33,
          $00, $02
        ]);
        WaitingForReply := True;
      end;

    psStepPosition: //step(������ġ)�� �ǽð����� ǥ��
      begin
        StatusBar1.Panels[1].Text := 'step��ġ ǥ��';
        SendModbusQuery
        ([
          $01,
          $03,
          $01, $18,
          $00, $02
        ]);
        WaitingForReply := True;
      end;

    psSpeedStatus: //���� �ӵ��� �ǽð����� ǥ��
      begin
        StatusBar1.Panels[1].Text := '�ӵ� ǥ��';
        SendModbusQuery
        ([
          $01,
          $03,
          $01, $1D,
          $00, $01
        ]);
        WaitingForReply := True;
      end;

    psSpeedInfo: //
      begin
        StatusBar1.Panels[1].Text := '���� ���� ǥ��';
        SendModbusQuery
        ([
          $01,
          $03,
          $02, $24,
          $00, $04
        ]);
        WaitingForReply := True;
      end;
  end;
end;

//�׽�Ʈ��
procedure TForm1.Button1Click(Sender: TObject);
begin
  SendModbusQuery
  ([
    $01,
    $06,
    $00, $40,
    $00, $03
  ]);
end;

end.
