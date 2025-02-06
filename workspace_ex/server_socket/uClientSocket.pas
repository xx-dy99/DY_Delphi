unit uClientSocket;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp;

type
  TForm1 = class(TForm)
    ClientSocket1: TClientSocket;
    edt1: TEdit;
    BtnSend: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    procedure BtnSendClick(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.BtnSendClick(Sender: TObject);
begin
 if not ClientSocket1.Active then
 begin
  ClientSocket1.Host := '127.0.0.1'; //�����ּ� (����)
  ClientSocket1.Port := 12345; //���� ��Ʈ
  ClientSocket1.Active := True; //���� ����
  Memo1.Lines.Add('Connected to server...');
  end;

  //�޽��� ����
  ClientSocket1.Socket.SendText(edt1.Text);
  Memo1.Lines.Add('Sent: ' + edt1.Text);
end;

procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
 Response: string;
begin
 Response := Socket.ReceiveText; //�������� ����
 Memo1.Lines.Add('Received: ' + Response);
end;

end.
