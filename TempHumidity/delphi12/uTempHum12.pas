unit uTempHum12;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.ExtCtrls, Vcl.StdCtrls,
  OverbyteIcsWndControl, OverbyteIcsWSocket, VCLTee.Series;

type
  TForm1 = class(TForm)
    WSocket: TWSocket;
    pnlStatus: TPanel;
    btnconnect: TButton;
    btnDisconnect: TButton;
    Label1: TLabel;
    Label2: TLabel;
    pnlTemp1: TPanel;
    pnlTemp18: TPanel;
    pnlHum1: TPanel;
    pnlHum18: TPanel;
    TimerRequest: TTimer;
    chrtTempHum1: TChart;
    chrtTempHum18: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    Memo1: TMemo;
    Button1: TButton;
    edtMax1: TEdit;
    edtMin1: TEdit;
    edtMax18: TEdit;
    edtMin18: TEdit;
    chkAuto1: TCheckBox;
    chkAuto18: TCheckBox;
    btnApplyRange1: TButton;
    btnApplyRange18: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure btnconnectClick(Sender: TObject);
    procedure WSocketSessionConnected(Sender: TObject; ErrCode: Word);
    procedure WSocketSessionClosed(Sender: TObject; ErrCode: Word);
    procedure btnDisconnectClick(Sender: TObject);
    procedure RequestTemperatureHumidity(deviceID: Byte);
    procedure WSocketDataAvailable(Sender: TObject; ErrCode: Word);
    procedure TimerRequestTimer(Sender: TObject);
    procedure AddData(deviceID: Byte; Temperature, Humidity: Double);
    procedure chkAuto1Click(Sender: TObject);
    procedure btnApplyRange1Click(Sender: TObject);
    procedure chkAuto18Click(Sender: TObject);
    procedure btnApplyRange18Click(Sender: TObject);
    {procedure Button1Click(Sender: TObject);}

    {procedure chrtTempHum1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chrtTempHum18MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);}

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  rcvData: Ansistring;
  currentDevice: Byte = 1;
  deviceID: Byte;

implementation

{$R *.dfm}

procedure TForm1.btnconnectClick(Sender: TObject);
begin
  WSocket.Close;
  WSocket.Addr := '192.168.127.254';
  WSocket.Port := '4001';
  WSocket.LineMode := False;
  WSocket.Connect;

  pnlStatus.Caption := '연결상태 : 연결 시도중...';
  pnlStatus.Color := clBlue;
  pnlStatus.Font.Color := clWhite;
end;

procedure TForm1.WSocketSessionConnected(Sender: TObject; ErrCode: Word);
begin
  if ErrCode = 0 then
  begin
    pnlStatus.Caption := '연결상태 : 연결됨';
    pnlStatus.Color := clLime;
    pnlStatus.Font.Color := clBlack;

    TimerRequest.Enabled := True;
    //RequestTemperatureHumidity();
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
  pnlStatus.Caption := '연결상태 : 끊어짐';
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;

  TimerRequest.Enabled := False;
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  WSocket.Close;

  pnlStatus.Caption := '연결상태 : 끊어짐';
  pnlStatus.Color := clGray;
  pnlStatus.Font.Color := clWhite;
end;

{procedure TForm1.Button1Click(Sender: TObject);
var
  c1:char;      //2
  c2:ansichar;  //1
  len:integer;

  s1:shortString; //256
  s2:ansiString;  //4
  s3:string;      //4
begin
  len:= sizeof(c1);
  Memo1.Lines.Add(inttostr(len));

  len:= sizeof(c2);
  Memo1.Lines.Add(inttostr(len));

  len:= sizeof(s1);
  Memo1.Lines.Add(inttostr(len));

  len:= sizeof(s2);
  Memo1.Lines.Add(inttostr(len));

  len:= sizeof(s3);
  Memo1.Lines.Add(inttostr(len));


  s1:= '12345';
  len:= sizeof(s1[1]);
  Memo1.Lines.Add(inttostr(len));

  s2:= '12345';
  len:= sizeof(s2[1]);
  Memo1.Lines.Add(inttostr(len));

  s3:= '12345';
  len:= sizeof(s3[1]);
  Memo1.Lines.Add(inttostr(len));


end;}


function getchecksum(s: Ansistring): Ansistring;
var
  crc : word;
  i, j: integer;
  byteValue: byte;
begin
  crc := $FFFF;

  for i := 1 to Length(s) do
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

  Result := AnsiChar(Lo(crc)) + AnsiChar(Hi(crc));
end;

procedure TForm1.RequestTemperatureHumidity(deviceID: Byte);
var
  cmd : AnsiString;
  len : integer;
begin
  rcvData := '';

  cmd := AnsiChar(deviceID) +
         AnsiChar($04) +
         AnsiChar($00) +
         AnsiChar($00) +
         AnsiChar($00) +
         AnsiChar($02);

  cmd := cmd + getchecksum(cmd);

  WSocket.SendStr(cmd);
end;

procedure TForm1.WSocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  str: Ansistring;
  len: integer;
  calCRC, rcvCRC: Ansistring;
  ch1, ch2: Ansichar;
  temp, hum: smallint;
  tempFloat, humFloat: Double;
  deviceID: Byte;
begin
  str := WSocket.ReceiveStrA;
  rcvData := rcvData + str;
  len := length(rcvData);

  if len < 9 then
  Exit;

  calCRC := getchecksum(copy(rcvData, 1, len-2));
  rcvCRC := copy(rcvData, len-1, 2);

  if calCRC <> rcvCRC then
  Exit;

  deviceID := Ord(rcvData[1]);
  ch1 := rcvData[4];
  ch2 := rcvData[5];
  temp := (ord(ch1) shl 8) or ord (ch2);
  tempFloat := temp / 100.0;

  ch1 := rcvData[6];
  ch2 := rcvData[7];
  hum := (ord(ch1) shl 8) or ord (ch2);
  humFloat := hum / 100.0;

  AddData(deviceID, tempFloat, humFloat);

  if deviceID = 1 then
  begin
    //Memo1.Lines.Add('수신: ' + FormatFloat('0.0', tempFloat));
    //ShowMessage('수신: ' + FormatFloat('0.0', tempFloat));
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
    RequestTemperatureHumidity(1);
    currentDevice := 18;
  end
  else
  begin
    RequestTemperatureHumidity(18);
    currentDevice := 1;
  end;
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

    chrtTempHum1.Repaint
  end
  else if deviceID = 18 then
  begin
    if Series3.Count >= 20 then Series3.Delete(0);
    if Series4.Count >= 20 then Series4.Delete(0);

    Series3.AddXY(CurrentTime, Temperature);
    Series4.AddXY(CurrentTime, Humidity);

    if Series1.Count > 1 then
    begin
      chrtTempHum1.BottomAxis.Automatic := False;
      chrtTempHum1.BottomAxis.Minimum := Series1.XValues[0];
      chrtTempHum1.BottomAxis.Maximum := Series1.XValues[Series1.Count - 1];
    end
    else
    begin
      chrtTempHum18.BottomAxis.Automatic := true;
    end;

    chrtTempHum18.Repaint
  end;
end;

{procedure TForm1.chrtTempHum1MouseMove(Sender: TObject; Shift: TShiftState;
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

    chrtTempHum1.Hint := Format('온도: %.1f℃ | 습도:%.1f%%', [TempValue, HumValue]);
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

    chrtTempHum18.Hint := Format('온도: %.1f℃ | 습도:%.1f%%', [TempValue, HumValue]);
    Application.ActivateHint(Mouse.CursorPos);
  end;
end;}

procedure TForm1.chkAuto1Click(Sender: TObject);
begin
  if chkAuto1.Checked then
  begin
    chrtTempHum1.LeftAxis.Automatic := True;

    edtMax1.Enabled := False;
    edtMin1.Enabled := False;
    btnApplyRange1.Enabled := False;
  end
  else
  begin
    chrtTempHum1.LeftAxis.Automatic := False;

    edtMax1.Enabled := True;
    edtMin1.Enabled := True;
    btnApplyRange1.Enabled := True;
  end;
end;

procedure TForm1.btnApplyRange1Click(Sender: TObject);
var
  NewMin, NewMax: Double;
begin
  if TryStrToFloat(edtMin1.Text, NewMin) and TryStrToFloat(edtMax1.Text, NewMax) then
    begin
      if NewMin >= NewMax then
      begin
        ShowMessage('최솟값이 최대값보다 큽니다! 쫌!');
        Exit;
      end;

      chrtTempHum1.LeftAxis.Automatic := False;

      chrtTempHum1.LeftAxis.Minimum := -999;
      chrtTempHum1.LeftAxis.Maximum := 999;

      chrtTempHum1.LeftAxis.Minimum := NewMin;
      chrtTempHum1.LeftAxis.Maximum := NewMax;
    end
    else
      ShowMessage('유효한숫자를 입력하세요!!!!!');
end;

procedure TForm1.chkAuto18Click(Sender: TObject);
begin
  if chkAuto18.Checked then
  begin
    chrtTempHum18.LeftAxis.Automatic := True;

    edtMax18.Enabled := False;
    edtMin18.Enabled := False;
    btnApplyRange18.Enabled := False;
  end
  else
  begin
      chrtTempHum18.LeftAxis.Automatic := False;

      edtMax18.Enabled := True;
      edtMin18.Enabled := True;
      btnApplyRange18.Enabled := True;
    end;
end;

procedure TForm1.btnApplyRange18Click(Sender: TObject);
var
  NewMin, NewMax: Double;
begin
  if TryStrToFloat(edtMin18.Text, NewMin) and TryStrToFloat(edtMax18.Text, NewMax) then
    begin
      if NewMin >= NewMax then
        begin
          ShowMessage('최솟값이...최댓값보다커요...하..');
          Exit;
        end;

      chrtTempHum18.LeftAxis.Automatic := False;

      chrtTempHum18.LeftAxis.Minimum := -999;
      chrtTempHum18.LeftAxis.Maximum := 999;

      chrtTempHum18.LeftAxis.Minimum := NewMin;
      chrtTempHum18.LeftAxis.Maximum := newMax;
    end
    else
      ShowMessage('유효한 숫자를 입력하세요!!!!!!!');
end;

end.
