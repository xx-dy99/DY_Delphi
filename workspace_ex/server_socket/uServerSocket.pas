unit uServerSocket;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp;

type
  TForm1 = class(TForm)
    ServerSocket1: TServerSocket;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
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

procedure TForm1.FormCreate(Sender: TObject);
begin
 ServerSocket1.Port := 12345; //서버포트 설정
 ServerSocket1.Active := True; //서버시작
 Memo1.Lines.Add('Server started on port 12345...');
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
 ReceivedData: string;
begin
 ReceivedData := Socket.ReceiveText; //클라이언트에서받은 데이터
 Memo1.Lines.Add('Received: ' + ReceivedData); //로그 출력
 Socket.SendText('OK'); //클라이언트에게 응답
end;

end.
