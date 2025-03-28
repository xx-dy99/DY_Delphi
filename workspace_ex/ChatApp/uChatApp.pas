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
    btnSend: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnNickname: TButton;
    ServerSocket1: TServerSocket;
    ClientSocket1: TClientSocket;
    btnStopServer: TButton;
    memoMessage: TMemo;
    procedure btnStartServerClick(Sender: TObject);
    procedure btnStartClientClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnNicknameClick(Sender: TObject);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    Procedure AddChatMessage(const Msg: string; IsSelf: Boolean);
    procedure btnStopServerClick(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure memoMessageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AdjustMemoHeight;
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
 btnStopServer.Enabled := True; //서버종료 버튼 활성화
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

 MessageText := SysUtils.Trim(memoMessage.Text); //앞뒤 공백 제거

 if (MessageText <> '') and (ClientSocket1.Active) then
 begin
  //한줄메시지 일경우 닉네임 옆에 붙여서 표기
  if memoMessage.Lines.Count = 1 then
   ClientSocket1.Socket.SendText(edtNickname.Text + ': ' + MessageText)
  else
   ClientSocket1.Socket.SendText(edtNickname.Text + ' 님: '#13#10 + MessageText);

  AddChatMessage('나 (' + edtNickname.Text + '): ' + MessageText, True);//파란색출력
  memoMessage.Clear; //입력창 초기화
  memoMessage.Height := 25; //메시지전송후높이 초기화.
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

 //서버종료 메시지 감지
 if ReceivedText = '알림: 서버가 종료되었습니다.' then
 begin
  RichEditChat.Lines.Add(ReceivedText);
  memoMessage.Enabled := False; //메시지 입력 창 비활성화
  btnSend.Enabled := False; //전송 버튼 비활성화
  RichEditChat.ReadOnly := True; //로그편집 못하도록 채팅창 읽기모드 활성화
  Exit;
 end;

 //서버에서 보내는 "알림:" 메시지를 감지하여 출력
 if Pos('알림:', ReceivedText) = 1 then
  RichEditChat.Lines.Add(ReceivedText)
 else
  //상대 메시지를 빨간색으로 출력
  AddChatMessage(ReceivedText, False);
end;

Procedure TForm1.AddChatMessage(const Msg: string; IsSelf: Boolean);
begin
 //기존텍스트 끝으로 이동
 RichEditChat.SelStart := RichEditChat.GetTextLen;

 //메시지 색상설정
 if IsSelf then
  RichEditChat.SelAttributes.Color := clBlue //내 메시지 파랑
 else
  RichEditChat.SelAttributes.Color := clRed; // 상대 메시지 빨강

 //메시지 추가
 RichEditChat.Lines.Add(SysUtils.Trim(Msg));

 //자동스크롤 텍스트 길어지면 넘어가는거
 RichEditChat.SelStart := RichEditChat.GetTextLen;
 RichEditChat.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TForm1.btnStopServerClick(Sender: TObject);
var
 i: Integer;
begin
 if ServerSocket1.Active then
 begin
 //모든 클라이언트에게 서버종료 메시지 전송
 for i := 0 to ServerSocket1.Socket.ActiveConnections -1 do
 begin
  ServerSocket1.Socket.Connections[i].SendText('알림: 서버가 종료되었습니다.');
 end;

  //서버종료
  ServerSocket1.Active := False; //서버 소켓 종료
  RichEditChat.Lines.Add('서버가 종료되었습니다.');

  //UI변경
  btnStartServer.Enabled := True; //서버 시작 버튼 활성화
  btnStopServer.Enabled := False; //서버 종료 버튼 비활성화
  btnStartClient.Enabled := True; //클라이언트 실행 버튼 활성화
  edtServerIP.Enabled := True; //서버IP 입력 활성화
 end;
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
 ClientIP: string;
 i: Integer;
begin
 ClientIP := Socket.RemoteAddress; //접속한 클라이언트의 IP주소

 //서버로그에 클라이언트 접속기록 출력
 RichEditChat.Lines.Add('클라이언트 접속: ' + ClientIP);

 //모든 클라이언트에게 새로운 클라이언트 접속알림
 for i := 0 to ServerSocket1.Socket.ActiveConnections - 1do
 begin
  ServerSocket1.Socket.Connections[i].SendText('알림: 클라이언트(' + ClientIP + ')가 접속했습니다.');
 end;
end;

procedure TForm1.memoMessageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Key = VK_RETURN) and (ssShift in Shift) then
 begin
  //Shift + Enter: 현재 커서 위치에 줄바꿈 추가
  memoMessage.SelText := #13#10;
  AdjustMemoHeight; //줄수에 따라 높이조정
  Key := 0; //(기본동작 방지)
  Exit;
 end
 else if (key = VK_RETURN) then
 begin
  btnSendClick(Sender); //메시지 전송;
  Key := 0;
 end;
end;

procedure TForm1.AdjustMemoHeight;
const
 MinHeight = 25; //기본높이(1줄)
 MaxHeight = 120; //최대높이 (8줄기준)
 LineHeight = 15; //한줄당 높이 증가값
var
 NewHeight, LineCount, HeightDiff: Integer;
begin
 //불필요한 빈 줄을 제거한 실제 줄개수 계산
 LineCount := memoMessage.Lines.Count;
 if (LineCount =0) or ((LineCount = 1) and (memoMessage.Lines[0] = '')) then
  LineCount := 1; //빈 경우 1줄로 처리

 NewHeight := MinHeight + ((LineCount - 1) * LineHeight);

 //최대8줄까지만 늘어나도록 제한
 if NewHeight > MaxHeight then
  NewHeight := MaxHeight;
 //현재 높이와의 차이 계산
 HeightDiff := NewHeight - memoMessage.Height;

 //변경된 높이 적용(위로 확장)
 memoMessage.Top := memoMessage.Top - HeightDiff; //위로 이동
 memoMessage.Height := NewHeight;
end;

end.
