unit uMotor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, WSocket, ExtCtrls;

type
  TForm1 = class(TForm)
    wSocket: TWSocket;
    btnConnect: TButton;
    btnSendCommand: TButton;
    Memo1: TMemo;
    pnlStatus: TPanel;
    btnDisconnect: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure btnSendCommandClick(Sender: TObject);
    procedure wSocketDataAvailable(Sender: TObject; ErrCode: Word);
    procedure wSocketSessionConnected(Sender: TObject; ErrCode: Word);
    procedure wSocketSessionClosed(Sender: TObject; ErrCode: Word);
    procedure btnDisconnectClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  rcvData : string;

implementation

{$R *.DFM}

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

{procedure TForm1.btnSendCommandClick(Sender: TObject);
var
  Query: array[0..7] of Byte;
begin
  if wSocket.State = wsConnected then
  begin
  //쿼리 구성 : 01, 06, 02, 1E, FF, FF, E9, C4
  Query[0] := $01;
  Query[1] := $06;
  Query[2] := $02;
  Query[3] := $1E;
  Query[4] := $FF;
  Query[5] := $FF;
  Query[6] := $E9;
  Query[7] := $C4;

  wSocket.Send(@Query, 8);
  end
  else
  begin
    ShowMessage('연결되지 않았습니다!');
    Exit;
  end;
end;}

{procedure TForm1.wSocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  Buffer: array[0..255] of Byte;
  Len, i: Integer;
  MsgStr: string;
begin

  Len := wSocket.Receive(@Buffer, SizeOf(Buffer));
  MsgStr := '';
  for i := 0 to Len -1 do
    MsgStr := MsgStr + IntToHex(Buffer[i], 2) + ' ';

  Memo1.Lines.Add('응답: ' + MsgStr);
end;}

procedure TForm1.btnSendCommandClick(Sender: TObject);
var
  Query : string;
begin
  //쿼리 구성 : 01, 06, 02, 1E, FF, FF, E9, C4
  Query := Char($01) +
           Char($06) +
           Char($02) +
           Char($1E) +
           Char($FF) +
           Char($FF) +
           Char($E9) +
           Char($C4);

  wSocket.SendStr(Query);
end;

procedure TForm1.wSocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  str : string;
  ch1, ch2, ch3, ch4, ch5 : char;
  Slave : double;

begin
  str := WSocket.ReceiveStr;
  rcvData := rcvData + str;

  ch1 := rcvData[1];
  ch2 := rcvData[2];
  ch3 := rcvData[3];
  ch4 := rcvData[4];
  ch5 := rcvData[5];
  Slave := ord(ch1) + ord(ch2) + ord(ch3) + ord(ch4) + ord(ch5);

  Memo1.Lines.Add('응답: ' + FloatToStr(Slave));
end;

end.
