unit uChatApp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ScktComp;

type
  TForm1 = class(TForm)
    btnStartServer: TButton;
    btnStartClient: TButton;
    edtServerIp: TEdit;
    RichEditChat: TRichEdit;
    edtNickname: TEdit;
    edtMessage: TEdit;
    btnSend: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnNickname: TButton;
    ServerSocket1: TServerSocket;
    ClientSocket1: TClientSocket;
    procedure btnStartServerClick(Sender: TObject);
    procedure btnStartClientClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnNicknameClick(Sender: TObject);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    Procedure AddChatMessage(const Msg: string; IsSelf: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnStartServerClick(Sender: TObject);
begin
 ServerSocket1.Port := 12345; //고정된 포트사용
 ServerSocket1.Active := True; // 서버시작
 RichEditChat.Lines.Add('서버가 시작되었습니다.');

 //UI변경 서버모드 활성화
 btnStartServer.Enabled := False;
 btnStartClient.Enabled := False;
 edtServerIP.Enabled := False;
end;

procedure TForm1.btnStartClientClick(Sender: TObject);
begin
 if edtServerIP.Text = '' then
 begin
  RichEditChat.Lines.Add('서버 IP를 입력하세요.');
  Exit;
 end;

 ClientSocket1.Host := edtServerIP.Text;
 ClientSocket1.Port := 12345; //서버와 같은 포트사용
 ClientSocket1.Active := True; //클라이언트 시작
 RichEditChat.Lines.Add('서버에 연결 요청중...');

 //UI 변경(클라이언트 모드 활성화)
 btnStartServer.Enabled := False;
 btnStartClient.Enabled := False;
 edtServerIP.Enabled := False;
end;

procedure TForm1.btnSendClick(Sender: TObject);
var
 MessageText: string;
begin
 if (edtNickname.Text = '') or (btnNickname.Enabled) then
 begin
  RichEditChat.Lines.Add('닉네임을 입력하세요.');
  Exit;
 end;

 MessageText := edtMessage.Text;

 if (MessageText <> '') and (ClientSocket1.Active) then
 begin
  ClientSocket1.Socket.SendText(edtNickname.Text + ': ' + MessageText);
  AddChatMessage('나 (' + edtNickname.Text + '): ' + MessageText, True);//파란색출력
  edtMessage.Text := ''; //입력창 초기화
 end
 else
  RichEditChat.Lines.Add('서버에 연결되지 않았거나 메시지가 비어있습니다.');
end;

procedure TForm1.btnNicknameClick(Sender: TObject);
begin
 if edtNickname.Text <> '' then
 begin
  RichEditChat.Lines.Add('닉네임이  "' + edtNickname.Text + '"으로 설정되었습니다.');
  edtNickname.Enabled := False; //닉네입입력창 비활성화
  btnNickname.Enabled := False; //닉네임 확인버튼 비활성화
 end
 else
  RichEditChat.Lines.Add('닉네임을 입력해주세요!');
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
 ReceivedText: string;
 i: Integer;
begin
 //클라이언트가 보낸 메시지 수신
 ReceivedText := Socket.ReceiveText;

 //서버로그에 메시지 출력
 RichEditChat.Lines.Add('클라이언트 (' + Socket.RemoteAddress + '): ' + ReceivedText);

 //메시지를 다른 모든 클라이언트들에게 전달
 for i := 0 to ServerSocket1.Socket.ActiveConnections -1 do
 begin
  if ServerSocket1.Socket.Connections[i] <> Socket then
   ServerSocket1.Socket.Connections[i].SendText(ReceivedText);
 end;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
 ReceivedText: string;
begin
 //서버에서 보낸 메시지를 수신
 ReceivedText := Socket.ReceiveText;

 //상대방 메시지를 빨간색으로 출력
 AddChatMessage(ReceivedText, False);
end;

Procedure TForm1.AddChatMessage(const Msg: string; IsSelf: Boolean);
begin
 //기존텍스트 끝으로 이동
 RichEditChat.SelStart := RichEditChat.GetTextLen;

 //메시지 색상설정
 if IsSelf then
  RichEditChat.SelAttributes.Color := clBlue //자신의 메시지 파랑색
 else
  RichEditChat.SelAttributes.Color := clRed; // 상대방의 메시지 빨강색

 //메시지 추가
 RichEditChat.Lines.Add(Msg);

 //자동스크롤
 RichEditChat.SelStart := RichEditChat.GetTextLen;
 RichEditChat.Perform(EM_SCROLLCARET, 0, 0);
end;

end.
