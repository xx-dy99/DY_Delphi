unit uChatClient;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp;

type
  TForm1 = class(TForm)
    ServerSocket1: TServerSocket;
    Memo1: TMemo;
    btnStart: TButton;
    btnStop: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnStartClick(Sender: TObject);
begin
 if not ServerSocket1.Active then
 begin
   ServerSocket1.Active := True;
   Memo1.Lines.Add('서버가 시작되었습니다. 포트 12345에서 대기중...');
 end
 else
   Memo1.Lines.Add('서버는 이미 실행중입니다.');
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
 if ServerSocket1.Active then
 begin
  ServerSocket1.Active := False;
  Memo1.Lines.Add('서버가 종료되었습니다.');
 end
 else
  Memo1.Lines.Add('서버는 이미 종료되어있습니다.');
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 Memo1.Lines.Add('클라이언트 접속됨: ' + Socket.RemoteAddress);
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
 ReceivedText: string;
 i: integer;
begin
 //클라이언트가 보낸 메시지 수신
 ReceivedText := Socket.ReceiveText;

 //서버 로그에 추가
 Memo1.Lines.Add('클라이언트 (' + Socket.RemoteAddress + '): ' + ReceivedText);

 //다른 클라이언트에게 메시지 중계
 for i := 0 to ServerSocket1.Socket.ActiveConnections - 1 do
 begin
  if ServerSocket1.Socket.Connections[i] <> Socket then
  begin
   ServerSocket1.Socket.Connections[i].SendText(ReceivedText);
  end;
 end;
end;

end.
