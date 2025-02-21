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
 ServerSocket1.Port := 12345; //������ ��Ʈ���
 ServerSocket1.Active := True; // ��������
 RichEditChat.Lines.Add('������ ���۵Ǿ����ϴ�.');

 //UI���� ������� Ȱ��ȭ
 btnStartServer.Enabled := False;
 btnStopServer.Enabled := True; //�������� ��ư Ȱ��ȭ
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

 MessageText := SysUtils.Trim(memoMessage.Text); //�յ� ���� ����

 if (MessageText <> '') and (ClientSocket1.Active) then
 begin
  //���ٸ޽��� �ϰ�� �г��� ���� �ٿ��� ǥ��
  if memoMessage.Lines.Count = 1 then
   ClientSocket1.Socket.SendText(edtNickname.Text + ': ' + MessageText)
  else
   ClientSocket1.Socket.SendText(edtNickname.Text + ' ��: '#13#10 + MessageText);

  AddChatMessage('�� (' + edtNickname.Text + '): ' + MessageText, True);//�Ķ������
  memoMessage.Clear; //�Է�â �ʱ�ȭ
  memoMessage.Height := 25; //�޽��������ĳ��� �ʱ�ȭ.
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

 //�������� �޽��� ����
 if ReceivedText = '�˸�: ������ ����Ǿ����ϴ�.' then
 begin
  RichEditChat.Lines.Add(ReceivedText);
  memoMessage.Enabled := False; //�޽��� �Է� â ��Ȱ��ȭ
  btnSend.Enabled := False; //���� ��ư ��Ȱ��ȭ
  RichEditChat.ReadOnly := True; //�α����� ���ϵ��� ä��â �б��� Ȱ��ȭ
  Exit;
 end;

 //�������� ������ "�˸�:" �޽����� �����Ͽ� ���
 if Pos('�˸�:', ReceivedText) = 1 then
  RichEditChat.Lines.Add(ReceivedText)
 else
  //��� �޽����� ���������� ���
  AddChatMessage(ReceivedText, False);
end;

Procedure TForm1.AddChatMessage(const Msg: string; IsSelf: Boolean);
begin
 //�����ؽ�Ʈ ������ �̵�
 RichEditChat.SelStart := RichEditChat.GetTextLen;

 //�޽��� ������
 if IsSelf then
  RichEditChat.SelAttributes.Color := clBlue //�� �޽��� �Ķ�
 else
  RichEditChat.SelAttributes.Color := clRed; // ��� �޽��� ����

 //�޽��� �߰�
 RichEditChat.Lines.Add(SysUtils.Trim(Msg));

 //�ڵ���ũ�� �ؽ�Ʈ ������� �Ѿ�°�
 RichEditChat.SelStart := RichEditChat.GetTextLen;
 RichEditChat.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TForm1.btnStopServerClick(Sender: TObject);
var
 i: Integer;
begin
 if ServerSocket1.Active then
 begin
 //��� Ŭ���̾�Ʈ���� �������� �޽��� ����
 for i := 0 to ServerSocket1.Socket.ActiveConnections -1 do
 begin
  ServerSocket1.Socket.Connections[i].SendText('�˸�: ������ ����Ǿ����ϴ�.');
 end;

  //��������
  ServerSocket1.Active := False; //���� ���� ����
  RichEditChat.Lines.Add('������ ����Ǿ����ϴ�.');

  //UI����
  btnStartServer.Enabled := True; //���� ���� ��ư Ȱ��ȭ
  btnStopServer.Enabled := False; //���� ���� ��ư ��Ȱ��ȭ
  btnStartClient.Enabled := True; //Ŭ���̾�Ʈ ���� ��ư Ȱ��ȭ
  edtServerIP.Enabled := True; //����IP �Է� Ȱ��ȭ
 end;
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
 ClientIP: string;
 i: Integer;
begin
 ClientIP := Socket.RemoteAddress; //������ Ŭ���̾�Ʈ�� IP�ּ�

 //�����α׿� Ŭ���̾�Ʈ ���ӱ�� ���
 RichEditChat.Lines.Add('Ŭ���̾�Ʈ ����: ' + ClientIP);

 //��� Ŭ���̾�Ʈ���� ���ο� Ŭ���̾�Ʈ ���Ӿ˸�
 for i := 0 to ServerSocket1.Socket.ActiveConnections - 1do
 begin
  ServerSocket1.Socket.Connections[i].SendText('�˸�: Ŭ���̾�Ʈ(' + ClientIP + ')�� �����߽��ϴ�.');
 end;
end;

procedure TForm1.memoMessageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Key = VK_RETURN) and (ssShift in Shift) then
 begin
  //Shift + Enter: ���� Ŀ�� ��ġ�� �ٹٲ� �߰�
  memoMessage.SelText := #13#10;
  AdjustMemoHeight; //�ټ��� ���� ��������
  Key := 0; //(�⺻���� ����)
  Exit;
 end
 else if (key = VK_RETURN) then
 begin
  btnSendClick(Sender); //�޽��� ����;
  Key := 0;
 end;
end;

procedure TForm1.AdjustMemoHeight;
const
 MinHeight = 25; //�⺻����(1��)
 MaxHeight = 120; //�ִ���� (8�ٱ���)
 LineHeight = 15; //���ٴ� ���� ������
var
 NewHeight, LineCount, HeightDiff: Integer;
begin
 //���ʿ��� �� ���� ������ ���� �ٰ��� ���
 LineCount := memoMessage.Lines.Count;
 if (LineCount =0) or ((LineCount = 1) and (memoMessage.Lines[0] = '')) then
  LineCount := 1; //�� ��� 1�ٷ� ó��

 NewHeight := MinHeight + ((LineCount - 1) * LineHeight);

 //�ִ�8�ٱ����� �þ���� ����
 if NewHeight > MaxHeight then
  NewHeight := MaxHeight;
 //���� ���̿��� ���� ���
 HeightDiff := NewHeight - memoMessage.Height;

 //����� ���� ����(���� Ȯ��)
 memoMessage.Top := memoMessage.Top - HeightDiff; //���� �̵�
 memoMessage.Height := NewHeight;
end;

end.
