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
  WSocket.Close;  // 기존 연결 종료
  WSocket.Addr := '192.168.127.254';  // IP
  WSocket.Port := '4001';  // 포트
  WSocket.LineMode := False;
  WSocket.Connect;  // 연결 시도

  //ui상태 변경
  pnlStatus.Caption := '연결 상태 : 연결시도중...';
  pnlStatus.Color := clBlue;
  pnlStatus.Font.Color := clWhite;
end;

procedure TForm1.WSocketSessionConnected(Sender: TObject; ErrCode: Word);
begin
  if ErrCode = 0 then //연결성공
  begin
    pnlStatus.Caption := '연결상태: 연결됨';
    pnlStatus.Color := clLime;
    pnlStatus.Font.Color := clBlack;

    //온습도 데이터 요청
    TimerRequest.Enabled := True;
    //RequestTemperatureHumidity(); (타이머 안으로 빠짐)
  end
  else
  begin
    pnlStatus.Caption := '연결상태 : 실패 (' + IntToStr(ErrCode) + ')';
    pnlStatus.Color := clRed;
    pnlStatus.Font.Color := clWhite;
  end;
end;

procedure TForm1.WSocketSessionClosed(Sender: TObject; ErrCode: Word);
begin
  pnlStatus.Caption := '연결 상태 : 끊어짐';
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;

  //데이터 요청 중지
  TimerRequest.Enabled := False;
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  WSocket.Close;

  //Ui상태 업데이트
  pnlStatus.Caption := '연결상태 : 끊어짐';
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;
end;

function getchecksum(s: string): string;
var
  crc: word;
  i, j: integer;
  byteValue: byte;
begin
  crc := $FFFF; //CRC초기값 설정

  for i := 1 to length(s) do // i값에 s문자열 길이 만큼 반복처리
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

  //결과를 little Endian으로 반환
  Result := Char(Lo(crc)) + Char(Hi(crc));
end;

procedure TForm1.RequestTemperatureHumidity(deviceID: Byte);
var
  cmd : string;
begin
  rcvData := ''; //데이터 초기화

  //Modbus패킷생성
  cmd := Char(deviceID) + //국번
         Char($04) + //명령
         Char($00) + // 시작 번지 상위 바이트
         Char($00) + // 시작 번지 하위 바이트
         Char($00) + // 읽을 개수 상위 바이트
         Char($02);  // 읽을 개수 하위 바이트

  cmd := cmd + getchecksum(cmd); //CRC추가
  WSocket.SendStr(cmd);//요청 전송
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

  if len < 9 then Exit; //데이터가 충분히 오지않으면 중단.

  //CRC검증
  calCRC := getchecksum(copy(rcvData, 1, len-2));
  rcvCRC := copy(rcvData, len-1, 2);

  if calCRC <> rcvCRC then Exit;
  {begin
    pnlStatus.Caption := 'CRC Error! 데이터 무효';
    pnlStatus.Color := clRed;
    Exit; // 오류발생 데이터무효
  end;

  pnlStatus.Caption := '데이터 정상 수신';
  pnlStatus.Color := clLime;}

  deviceID := Ord(rcvData[1]);//첫번째 바이트가 국번임.

  //온도 데이터 변환
  ch1 := rcvData[4];
  ch2 := rcvData[5];
  temp := (ord(ch1) shl 8) or ord(ch2);
  tempFloat := temp / 100.0; //실수변환

  //습도 데이터 변환
  ch1 := rcvData[6];
  ch2 := rcvData[7];
  hum := (ord(ch1) shl 8) or ord(ch2);
  humFloat := hum / 100.0; //실수변환

  //국번에 따라 패널에 데이터 실시간 표시 위치결정
  if deviceID = 1 then
  begin
    pnlTemp1.Caption := '온도: ' + FormatFloat('0.0', tempFloat) + '℃';
    pnlHum1.Caption := '습도: ' + FormatFloat('0.0', humFloat) + '%';
  end
  else if deviceID = 18 then
  begin
    pnlTemp18.Caption := '온도: ' + FormatFloat('0.0', tempFloat) + '℃';
    pnlHum18.Caption := '습도: ' + FormatFloat('0.0', humFloat) + '%';
  end;
end;


procedure TForm1.TimerRequestTimer(Sender: TObject);
begin
  if currentDevice = 1 then
  begin
    RequestTemperatureHumidity(1); // 온습도 데이터 요청 (타이머안으로 빠짐)
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
