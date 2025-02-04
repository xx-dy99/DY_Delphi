unit uDoking;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    btnModal: TButton;
    btnModeless: TButton;
    btnOnce: TButton;
    procedure btnModalClick(Sender: TObject);
    procedure btnModelessClick(Sender: TObject);
    procedure btnOnceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses Unit2, Unit3;

{$R *.DFM}

procedure TMainForm.btnModalClick(Sender: TObject);
var
P:TPoint;
begin
//버튼 위치 알아내기
P.x:=btnModal.Left;
P.y:=btnModal.Top;
P:=ClientToScreen(P);

//폼생성학 버튼 밑에서 보여주기
frmModal:= TfrmModal.Create(Self);
try
 frmModal.Top:=P.y + btnModal.Height;
 frmModal.Left:=P.x + btnModal.Width div 2;
 frmModal.ShowModal;
 if frmModal.ModalResult = mrOk then
 begin
  Application.MessageBox('mrOK리턴!, 모달 폼 닫힘!', 'Modal', MB_OK);
 end;
finally
 frmModal.Free;
end;
end;

procedure TMainForm.btnModelessClick(Sender: TObject);
begin
frmModeless:= TfrmModeless.Create(Self);
frmModeless.Show;
end;

procedure TMainForm.btnOnceClick(Sender: TObject);
var
frmModeless:TfrmModeless;
iFound,i:integer;
begin
iFound:=-1;
for i:=0 to Screen.FormCount-1 do
 if Screen.Forms[i] is TfrmModeless then
  iFound:=i;
 if iFound>=0 then begin
  ShowMessage('frmModeless 폼이 이미 있습니다! 이폼을 보여드리겠습니다...');
  Screen.Forms[iFound].Show;
 end else begin
  ShowMessage('frmModeless 폼을 새로 만들어 보여 드리겠습니다!');
  frmModeless:=TfrmModeless.Create(self);
  frmModeless.Show;
end;
end;

end.
