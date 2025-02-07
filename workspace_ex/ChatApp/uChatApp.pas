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
 ServerSocket1.Port := 12345; //������ ��Ʈ���
 ServerSocket1.Active := True; // ��������
 RichEditChat.Lines.Add('������ ���۵Ǿ����ϴ�.');

 //UI���� ������� Ȱ��ȭ
 btnStartServer.Enabled := False;
 btnStartClient.Enabled := False;
 edtServerIP.Enabled := False;
end;

procedure TForm1.btnStartClientClick(Sender: TObject);
begin
 if edtServerIP.Text = '' then
 begin
  RichEditChat.Lines.Add('���� IP�� �Է��ϼ���.');
  Exit;
 end;

 ClientSocket1.Host := edtServerIP.Text;
 ClientSocket1.Port := 12345; //������ ���� ��Ʈ���
 ClientSocket1.Active := True; //Ŭ���̾�Ʈ ����
 RichEditChat.Lines.Add('������ ���� ��û��...');

 //UI ����(Ŭ���̾�Ʈ ��� Ȱ��ȭ)
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
  RichEditChat.Lines.Add('�г����� �Է��ϼ���.');
  Exit;
 end;

 MessageText := edtMessage.Text;

 if (MessageText <> '') and (ClientSocket1.Active) then
 begin
  ClientSocket1.Socket.SendText(edtNickname.Text + ': ' + MessageText);
  AddChatMessage('�� (' + edtNickname.Text + '): ' + MessageText, True);//�Ķ������
  edtMessage.Text := ''; //�Է�â �ʱ�ȭ
 end
 else
  RichEditChat.Lines.Add('������ ������� �ʾҰų� �޽����� ����ֽ��ϴ�.');
end;

procedure TForm1.btnNicknameClick(Sender: TObject);
begin
 if edtNickname.Text <> '' then
 begin
  RichEditChat.Lines.Add('�г�����  "' + edtNickname.Text + '"���� �����Ǿ����ϴ�.');
  edtNickname.Enabled := False; //�г����Է�â ��Ȱ��ȭ
  btnNickname.Enabled := False; //�г��� Ȯ�ι�ư ��Ȱ��ȭ
 end
 else
  RichEditChat.Lines.Add('�г����� �Է����ּ���!');
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
 ReceivedText: string;
 i: Integer;
begin
 //Ŭ���̾�Ʈ�� ���� �޽��� ����
 ReceivedText := Socket.ReceiveText;

 //�����α׿� �޽��� ���
 RichEditChat.Lines.Add('Ŭ���̾�Ʈ (' + Socket.RemoteAddress + '): ' + ReceivedText);

 //�޽����� �ٸ� ��� Ŭ���̾�Ʈ�鿡�� ����
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
 //�������� ���� �޽����� ����
 ReceivedText := Socket.ReceiveText;

 //���� �޽����� ���������� ���
 AddChatMessage(ReceivedText, False);
end;

Procedure TForm1.AddChatMessage(const Msg: string; IsSelf: Boolean);
begin
 //�����ؽ�Ʈ ������ �̵�
 RichEditChat.SelStart := RichEditChat.GetTextLen;

 //�޽��� ������
 if IsSelf then
  RichEditChat.SelAttributes.Color := clBlue //�ڽ��� �޽��� �Ķ���
 else
  RichEditChat.SelAttributes.Color := clRed; // ������ �޽��� ������

 //�޽��� �߰�
 RichEditChat.Lines.Add(Msg);

 //�ڵ���ũ��
 RichEditChat.SelStart := RichEditChat.GetTextLen;
 RichEditChat.Perform(EM_SCROLLCARET, 0, 0);
end;

end.
