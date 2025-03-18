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
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Series3: TFastLineSeries;
    Series4: TFastLineSeries;
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

procedure TForm1.WSocketSessionClosed(Sender: TObject; ErrCode: Word);
begin
  pnlStatus.Caption := '���� ���� : ������';
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;

  //������ ��û ����
  TimerRequest.Enabled := False;
end;

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
    Series1.AddXY(CurrentTime, Temperature);
    HumGraph1.AddXY(CurrentTime, Humidity);
  end
  else if deviceID = 18 then
  begin
    TempGraph18.AddXY(CurrentTime, Temperature);
    HumGraph18.AddXY(CurrentTime, Humidity);
  end;
end;

end.
