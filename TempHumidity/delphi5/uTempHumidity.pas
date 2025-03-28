unit uTempHumidity;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WSocket, WSocketS, StdCtrls, Spin, ExtCtrls, ImgList, Buttons, AdvPicture,
  Menus, TeEngine, Series, TeeProcs, Chart;

type
  TForm1 = class(TForm)
    btnconnect: TButton;
    btnDisconnect: TButton;
    WSocket: TWSocket;
    pnlStatus: TPanel;
    pnlTemp1: TPanel;
    pnlHum1: TPanel;
    TimerRequest: TTimer;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    pnlTemp18: TPanel;
    pnlHum18: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    chrtTempHum1: TChart;
    chrtTempHum18: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    procedure btnconnectClick(Sender: TObject);
    procedure WSocketSessionConnected(Sender: TObject; ErrCode: Word);
    procedure WSocketSessionClosed(Sender: TObject; ErrCode: Word);
    procedure btnDisconnectClick(Sender: TObject);
    procedure RequestTemperatureHumidity(deviceID: Byte);
    procedure WSocketDataAvailable(Sender: TObject; ErrCode: Word);
    procedure TimerRequestTimer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure AddData(deviceID: Byte; Temperature, Humidity: Double);
    procedure chrtTempHum1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure chrtTempHum18MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  rcvData: string;
  currentDevice: Byte = 1;
  deviceID: Byte;

implementation

{$R *.DFM}

//��ư Ŭ���ؼ� �½������ ����
procedure TForm1.btnconnectClick(Sender: TObject);

begin
  WSocket.Close;  // ���� ���� ����
  WSocket.Addr := '192.168.127.254';  // IP
  WSocket.Port := '4001';  // ��Ʈ
  WSocket.LineMode := False;
  WSocket.Connect;  // ���� �õ�

  //ui���� ����
  pnlStatus.Caption := '���� ���� : ����õ���...';
  pnlStatus.Color := clBlue;
  pnlStatus.Font.Color := clWhite;
end;

//�����̵����� �г� ��ȭ �� �½��� ������ ��û
procedure TForm1.WSocketSessionConnected(Sender: TObject; ErrCode: Word);
begin
  if ErrCode = 0 then //���Ἲ��
  begin
    pnlStatus.Caption := '�������: �����';
    pnlStatus.Color := clLime;
    pnlStatus.Font.Color := clBlack;

    //�½��� ������ ��û
    TimerRequest.Enabled := True;
    //RequestTemperatureHumidity(); (Ÿ�̸� ������ ����)
  end
  else
  begin
    pnlStatus.Caption := '������� : ���� (' + IntToStr(ErrCode) + ')';
    pnlStatus.Color := clRed;
    pnlStatus.Font.Color := clWhite;
  end;
end;

//������ ���������� �гλ��� �� ������ ��û ����
procedure TForm1.WSocketSessionClosed(Sender: TObject; ErrCode: Word);
begin
  pnlStatus.Caption := '���� ���� : ������';
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;

  //������ ��û ����
  TimerRequest.Enabled := False;
end;

// �������� ��ư �������� ��
procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  WSocket.Close;

  //Ui���� ������Ʈ
  pnlStatus.Caption := '������� : ������';
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;
end;

function getchecksum(s: string): string;
var
  crc: word;
  i, j: integer;
  byteValue: byte;
begin
  crc := $FFFF; //CRC�ʱⰪ ����

  for i := 1 to length(s) do // i���� s���ڿ� ���� ��ŭ �ݺ�ó��
  begin
    byteValue := byte(s[i]);
    crc := crc xor byteValue;

    for j := 0 to 7 do
    begin
      if (crc and 1) <> 0 then
        crc := (crc shr 1) xor $A001
      else
        crc := crc shr 1;
    end;
  end;

  //����� little Endian���� ��ȯ
  Result := Char(Lo(crc)) + Char(Hi(crc));
end;

procedure TForm1.RequestTemperatureHumidity(deviceID: Byte);
var
  cmd : string;
begin
  rcvData := ''; //������ �ʱ�ȭ

  //Modbus��Ŷ����
  cmd := Char(deviceID) + //����
         Char($04) + //���
         Char($00) + // ���� ���� ���� ����Ʈ
         Char($00) + // ���� ���� ���� ����Ʈ
         Char($00) + // ���� ���� ���� ����Ʈ
         Char($02);  // ���� ���� ���� ����Ʈ

  cmd := cmd + getchecksum(cmd); //CRC�߰�
  WSocket.SendStr(cmd);//��û ����
end;

procedure TForm1.WSocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  str : string;
  len : integer;
  calCRC, rcvCRC : string;
  ch1, ch2 : char;
  temp, hum : smallint;
  tempFloat, humFloat : Double;
  deviceID: Byte;
begin
  str := WSocket.ReceiveStr;
  rcvData := rcvData + str;
  len := length(rcvData);

  if len < 9 then Exit; //�����Ͱ� ����� ���������� �ߴ�.

  //CRC����
  calCRC := getchecksum(copy(rcvData, 1, len-2));
  rcvCRC := copy(rcvData, len-1, 2);

  if calCRC <> rcvCRC then Exit;
  {begin
    pnlStatus.Caption := 'CRC Error! ������ ��ȿ';
    pnlStatus.Color := clRed;
    Exit; // �����߻� �����͹�ȿ
  end;

  pnlStatus.Caption := '������ ���� ����';
  pnlStatus.Color := clLime;}

  deviceID := Ord(rcvData[1]);//ù��° ����Ʈ�� ������.

  //�µ� ������ ��ȯ
  ch1 := rcvData[4];
  ch2 := rcvData[5];
  temp := (ord(ch1) shl 8) or ord(ch2);
  tempFloat := temp / 100.0; //�Ǽ���ȯ

  //���� ������ ��ȯ
  ch1 := rcvData[6];
  ch2 := rcvData[7];
  hum := (ord(ch1) shl 8) or ord(ch2);
  humFloat := hum / 100.0; //�Ǽ���ȯ

  AddData(deviceID, tempFloat, humFloat);

  //������ ���� �гο� ������ �ǽð� ǥ�� ��ġ����
  if deviceID = 1 then
  begin
    pnlTemp1.Caption := '�µ�: ' + FormatFloat('0.0', tempFloat) + '��';
    pnlHum1.Caption := '����: ' + FormatFloat('0.0', humFloat) + '%';
  end
  else if deviceID = 18 then
  begin
    pnlTemp18.Caption := '�µ�: ' + FormatFloat('0.0', tempFloat) + '��';
    pnlHum18.Caption := '����: ' + FormatFloat('0.0', humFloat) + '%';
  end;
end;


procedure TForm1.TimerRequestTimer(Sender: TObject);
begin
  if currentDevice = 1 then
  begin
    RequestTemperatureHumidity(1); // �½��� ������ ��û (Ÿ�̸Ӿ����� ����)
    currentDevice := 18;
  end
  else
  begin
    RequestTemperatureHumidity(18);
    currentDevice := 1;
  end;
end;


procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  btnConnectClick(Sender);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  btnDisconnectClick(Sender);
end;

procedure TForm1.AddData(deviceID: Byte; Temperature, Humidity: Double);
var
  CurrentTime: TDateTime;
begin
  CurrentTime := now;

  if deviceID = 1 then
  begin
    if Series1.Count >= 20 then Series1.Delete(0);
    if Series2.Count >= 20 then Series2.Delete(0);

    Series1.AddXY(CurrentTime, Temperature);
    Series2.AddXY(CurrentTime, Humidity);

    if Series1.Count > 1 then
    begin
      chrtTempHum1.BottomAxis.Automatic := False;
      chrtTempHum1.BottomAxis.Minimum := Series1.XValues[0];
      chrtTempHum1.BottomAxis.Maximum := Series1.XValues[Series1.Count - 1];
    end
    else
    begin
      chrtTempHum1.BottomAxis.Automatic := true;
    end;

    chrtTempHum1.Repaint;
  end
  else if deviceID = 18 then
  begin
    if Series3.Count >= 20 then Series3.Delete(0);
    if Series4.Count >= 20 then Series4.Delete(0);

    Series3.AddXY(CurrentTime, Temperature);
    Series4.AddXY(CurrentTime, Humidity);

    if Series3.Count > 1then
    begin
      chrtTempHum18.BottomAxis.Automatic := False;
      chrtTempHum18.BottomAxis.Minimum := Series1.XValues[0];
      chrtTempHum18.BottomAxis.Maximum := Series1.XValues[Series3.Count - 1];
    end
    else
    begin
      chrtTempHum18.BottomAxis.Automatic := true;
    end;

    chrtTempHum18.Repaint;
  end;
end;

procedure TForm1.chrtTempHum1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  NearestPointTemp, NearestPointHum: integer;
  TempValue, HumValue: Double;
begin
  NearestPointTemp := Series1.Clicked(X, Y);
  NearestPointHum := Series2.Clicked(X, Y);

  if (NearestPointTemp <> -1) and (NearestPointTemp <> -1) and
     (NearestPointHum <> -1) and (NearestPointHum < Series2.Count) then
  begin
    TempValue := Series1.YValues[NearestPointTemp];
    HumValue := Series2.YValues[NearestPointHum];

    chrtTempHum1.Hint := Format('�µ�: %.1f�� | ����:%.1f%%', [TempValue, HumValue]);
    Application.ActivateHint(Mouse.CursorPos);
  end;
end;

procedure TForm1.chrtTempHum18MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  NearestPointTemp, NearestPointHum: integer;
  TempValue, HumValue: Double;
begin
  NearestPointTemp := Series3.Clicked(X, Y);
  NearestPointHum := Series4.Clicked(X, Y);

  if (NearestPointTemp <> -1) and (NearestPointTemp <> -1) and
     (NearestPointHum <> -1) and (NearestPointHum < Series2.Count) then
  begin
    TempValue := Series3.YValues[NearestPointTemp];
    HumValue := Series4.YValues[NearestPointHum];

    chrtTempHum18.Hint := Format('�µ�: %.1f�� | ����:%.1f%%', [TempValue, HumValue]);
    Application.ActivateHint(Mouse.CursorPos);
  end;
end;

end.
