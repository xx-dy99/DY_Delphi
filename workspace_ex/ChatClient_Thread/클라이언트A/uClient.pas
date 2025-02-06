unit uClient;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp, ComCtrls;

type
  TForm1 = class(TForm)
    ClientSocket1: TClientSocket;
    Button1: TButton;
    edtMessage: TEdit;
    bntSend: TButton;
    btnSetNickname: TButton;
    edtNickname: TEdit;
    RichEditChat: TRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure bntSendClick(Sender: TObject);
    procedure btnSetNicknameClick(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure AddChatMessage(const Msg: string; IsSelf: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  UserNickname : string; //닉네임을 저장할 변수.

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
 if not ClientSocket1.Active then
 begin
  ClientSocket1.Active := True;
  RichEditChat.Lines.Add('서버에 연결 요청 중...');
 end
 else
  RichEditChat.Lines.Add('이미 서버에 연결되어 있습니다.');
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 RichEditChat.Lines.Add('서버에 연결되었습니다.');
end;


procedure TForm1.bntSendClick(Sender: TObject);
var
 MessageText: string;
begin
 //메시지를 입력하지 않았거나 닉네임이 설정되지 않은경우.
 if (UserNickname = '') then
 begin
  RichEditChat.Lines.Add('먼저 닉네임을 설정하세요.');
  Exit;
 end;

 MessageText := edtMessage.Text;

 if (MessageText <> '') and (ClientSocket1.Active) then
 begin
  ClientSocket1.Socket.SendText(UserNickname + ': ' + MessageText);
  AddChatMessage('나(' + UserNickname + '): ' + MessageText, True); //채팅로그에 표시
  edtMessage.Text := '';//입력창 초기화
 end
 else
  RichEditChat.Lines.Add('서버에 연결되지 않았거나 메시지가 비어 있습니다.');
end;

procedure TForm1.btnSetNicknameClick(Sender: TObject);
begin
 UserNickname := edtNickname.Text;

 if UserNickname <> '' then
 begin
  RichEditChat.Lines.Add('닉네임이"' + UserNickname + '"으로 설정되었습니다.');
  edtNickname.Enabled := False; //닉네임 수정불가능
  btnSetNickname.Enabled := False; //닉네임설정버튼 비활성화
 end
 else
  RichEditChat.Lines.Add('닉네임을 입력해주세요!');
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

procedure TForm1.AddChatMessage(const Msg: string; IsSelf: Boolean);
begin
 //기존텍스트 끝으로 이동
 RichEditChat.SelStart := RichEditChat.GetTextLen;
 //메시지 색상 설정
 if IsSelf then
  RichEditChat.SelAttributes.Color := clBlue //자신의 메시지: 파란색
 else
  RichEditChat.SelAttributes.Color := clRed; //상대방의 메시지 : 빨간색
 //메시지 추가
 RichEditChat.Lines.Add(Msg);
 //자동 스크롤
 RichEditChat.SelStart := RichEditChat.GetTextLen;
 RichEditChat.Perform(EM_SCROLLCARET, 0, 0);
end;

end.
