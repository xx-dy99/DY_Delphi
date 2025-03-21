unit uBarcode;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OoMisc, AdPort;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Memo1: TMemo;
    btnPortOpen: TButton;
    btnPortClose: TButton;
    btnTriggerScan: TButton;
    procedure btnPortOpenClick(Sender: TObject);
    procedure btnPortCloseClick(Sender: TObject);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTriggerScanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PartialData: string = ''; //���ڵ� �����͸� ���� �����ϴ� ����

implementation

{$R *.DFM}

procedure TForm1.btnPortOpenClick(Sender: TObject);
begin
  if not Assigned(ApdComPort1) then
  begin
    ShowMessage('��Ʈ�� �ʱ�ȭ ���� �ʾҽ��ϴ�.');
    Exit;
  end;

  if ApdComport1.Open then
  begin
    ShowMessage('�̹� ��Ʈ�� �����ֽ��ϴ�.');
    Exit;
  end;

  ApdComPort1.TriggerLength := 1;

  try
    ApdComPort1.Open := True;
    ShowMessage('��Ʈ�� ���Ƚ��ϴ�.');
  except
    on E: Exception do
      ShowMessage('��Ʈ���� ����:' + E.Message);
  end;
end;

procedure TForm1.btnPortCloseClick(Sender: TObject);
begin
  if Assigned(ApdComPort1) and ApdComPort1.Open then
  begin
    ApdComPort1.Open := False;
    ShowMessage('��Ʈ�� �������ϴ�.');
  end
  else
    ShowMessage('��Ʈ�� �̹� ���� �ֽ��ϴ�.');
end;

procedure TForm1.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
var
  ReceivedData: array[0..255] of char; //�ִ� 256����Ʈ �б�
  DataStr: string;
begin
  FillChar(ReceivedData, Sizeof(ReceivedData), 0); //�迭 �ʱ�ȭ
  ApdComPort1.GetBlock(ReceivedData, Count); //������ �б�
  DataStr := StrPas(ReceivedData); //PChar -> String��ȯ

  if Pos(#2, DataStr) > 0 then  // <STX> ���� �� ���ο� ���ڵ� ����
    PartialData := '';

  PartialData := PartialData + DataStr;// ������ ���� ����

  // <STX>, <CR>, <LF> ����
  PartialData := StringReplace(PartialData, #2, '', [rfReplaceAll]);  
  PartialData := StringReplace(PartialData, #13, '', [rfReplaceAll]); 
  PartialData := StringReplace(PartialData, #10, '', [rfReplaceAll]);

  if Length(PartialData) < 8 then Exit;// �ʹ� ª�� ������ ����

  if (Pos(#13, DataStr) > 0) or (Pos(#10, DataStr) > 0) then
  begin
    Memo1.Lines.Add(PartialData);
    PartialData := '';
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(ApdComPort1) and ApdComPort1.Open then
  begin
    ApdComPort1.Open := False;
    ShowMessage('���α׷� ����: ��Ʈ�� �������ϴ�.');
  end;
end;

procedure TForm1.btnTriggerScanClick(Sender: TObject);
begin
  if ApdComPort1.Open then
  begin
    //ApdComPort1.PutChar(#2);
    ApdComPort1.Output := #2;
    ShowMessage('��ĵ ����� �����߽��ϴ�.');
  end
  else
    ShowMessage('��Ʈ�� �������� �ʽ��ϴ�.');
end;

end.
