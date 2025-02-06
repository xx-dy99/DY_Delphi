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
  UserNickname : string; //�г����� ������ ����.

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
 if not ClientSocket1.Active then
 begin
  ClientSocket1.Active := True;
  RichEditChat.Lines.Add('������ ���� ��û ��...');
 end
 else
  RichEditChat.Lines.Add('�̹� ������ ����Ǿ� �ֽ��ϴ�.');
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 RichEditChat.Lines.Add('������ ����Ǿ����ϴ�.');
end;


procedure TForm1.bntSendClick(Sender: TObject);
var
 MessageText: string;
begin
 //�޽����� �Է����� �ʾҰų� �г����� �������� �������.
 if (UserNickname = '') then
 begin
  RichEditChat.Lines.Add('���� �г����� �����ϼ���.');
  Exit;
 end;

 MessageText := edtMessage.Text;

 if (MessageText <> '') and (ClientSocket1.Active) then
 begin
  ClientSocket1.Socket.SendText(UserNickname + ': ' + MessageText);
  AddChatMessage('��(' + UserNickname + '): ' + MessageText, True); //ä�÷α׿� ǥ��
  edtMessage.Text := '';//�Է�â �ʱ�ȭ
 end
 else
  RichEditChat.Lines.Add('������ ������� �ʾҰų� �޽����� ��� �ֽ��ϴ�.');
end;

procedure TForm1.btnSetNicknameClick(Sender: TObject);
begin
 UserNickname := edtNickname.Text;

 if UserNickname <> '' then
 begin
  RichEditChat.Lines.Add('�г�����"' + UserNickname + '"���� �����Ǿ����ϴ�.');
  edtNickname.Enabled := False; //�г��� �����Ұ���
  btnSetNickname.Enabled := False; //�г��Ӽ�����ư ��Ȱ��ȭ
 end
 else
  RichEditChat.Lines.Add('�г����� �Է����ּ���!');
end;

procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
 ReceivedText: string;
begin
 //�������� ���� �޽����� ����
 ReceivedText := Socket.ReceiveText;

 //���� �޽����� ���������� ���
 AddChatMessage(ReceivedText, False);
end;

procedure TForm1.AddChatMessage(const Msg: string; IsSelf: Boolean);
begin
 //�����ؽ�Ʈ ������ �̵�
 RichEditChat.SelStart := RichEditChat.GetTextLen;
 //�޽��� ���� ����
 if IsSelf then
  RichEditChat.SelAttributes.Color := clBlue //�ڽ��� �޽���: �Ķ���
 else
  RichEditChat.SelAttributes.Color := clRed; //������ �޽��� : ������
 //�޽��� �߰�
 RichEditChat.Lines.Add(Msg);
 //�ڵ� ��ũ��
 RichEditChat.SelStart := RichEditChat.GetTextLen;
 RichEditChat.Perform(EM_SCROLLCARET, 0, 0);
end;

end.
