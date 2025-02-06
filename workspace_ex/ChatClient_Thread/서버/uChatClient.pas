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
   Memo1.Lines.Add('������ ���۵Ǿ����ϴ�. ��Ʈ 12345���� �����...');
 end
 else
   Memo1.Lines.Add('������ �̹� �������Դϴ�.');
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
 if ServerSocket1.Active then
 begin
  ServerSocket1.Active := False;
  Memo1.Lines.Add('������ ����Ǿ����ϴ�.');
 end
 else
  Memo1.Lines.Add('������ �̹� ����Ǿ��ֽ��ϴ�.');
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 Memo1.Lines.Add('Ŭ���̾�Ʈ ���ӵ�: ' + Socket.RemoteAddress);
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
 ReceivedText: string;
 i: integer;
begin
 //Ŭ���̾�Ʈ�� ���� �޽��� ����
 ReceivedText := Socket.ReceiveText;

 //���� �α׿� �߰�
 Memo1.Lines.Add('Ŭ���̾�Ʈ (' + Socket.RemoteAddress + '): ' + ReceivedText);

 //�ٸ� Ŭ���̾�Ʈ���� �޽��� �߰�
 for i := 0 to ServerSocket1.Socket.ActiveConnections - 1 do
 begin
  if ServerSocket1.Socket.Connections[i] <> Socket then
  begin
   ServerSocket1.Socket.Connections[i].SendText(ReceivedText);
  end;
 end;
end;

end.
