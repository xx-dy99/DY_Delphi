unit uBarcode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, OoMisc, AdPort;

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
  //���� PartialData: string = '';
  PartialData: AnsiString = '';

implementation

{$R *.dfm}

procedure TForm1.btnPortOpenClick(Sender: TObject);
begin
  if not Assigned(ApdComPort1) then
  begin
    ShowMessage('��Ʈ�� �ʱ�ȭ ���� �ʾҽ��ϴ�.');
    Exit;
  end;

  if ApdComPort1.Open then
  begin
    ShowMessage('�̹� ��Ʈ�� �����ֽ��ϴ�.');
    Exit;
  end;

  ApdComPort1.TriggerLength := 1; //���ڵ帮���Ⱑ �����͸� 1����Ʈ ������.

  try //����(����)�� �߻��Ҽ��ִ� �ڵ��� ���� �߻��Ұ�� except������� �̵��Ͽ� ������ ó��.
    ApdComPort1.Open := True; //���ڵ� �����͸� �����غ���.
    ShowMessage('��Ʈ�� ���Ƚ��ϴ�.');
  except
    on E: Exception do //����(����)�� ��Ƽ� E��� ������ �����ϰ� �����޽��� Ȯ��.
      ShowMessage('��Ʈ ���� ����:' + E.Message);
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
  //���� ReceivedData: array[0..255] of char;
  ReceivedData: array[0..255] of Byte;
  DataStr: AnsiString;
  I: Integer;//�߰�
begin
  FillChar(ReceivedData, Sizeof(ReceivedData), 0);
  ApdComPort1.GetBlock(ReceivedData, Count);
  // ���� (����)DataStr := StrPas(ReceivedData);

  //�߰� ����Ʈ �����͸� AnsiString���� ��ȯ
  SetLength(DataStr, Count);
  for I := 0 to Count - 1 do
    DataStr[I + 1] := AnsiChar(ReceivedData[I]);

  //<STX>���� �� ���ο� ���ڵ� ����
  if Pos(#2, DataStr) > 0 then
    PartialData := '';

  //������ ���� ����
  PartialData := PartialData + DataStr;

  // <STX>, <CR>, <LF> ����
  PartialData := StringReplace(PartialData, #2, '', [rfReplaceAll]);
  PartialData := StringReplace(PartialData, #13, '', [rfReplaceAll]);
  PartialData := StringReplace(PartialData, #10, '', [rfReplaceAll]);

  // �ʹ� ª�� ������ ����
  if Length(PartialData) < 8 then Exit;

  if (Pos(#13, DataStr) > 0) or (Pos(#10, DataStr) > 0) then
  begin
    //���� Memo1.Lines.Add(PartialData);
    Memo1.Lines.Add(string(PartialData));//�߰� AnsiString�� Unicode�κ�ȯ�� Memo1�� �߰�
    Memo1.SelStart := Length(Memo1.Text); //�ڵ���ũ�� �̵�
    SendMessage(Memo1.Handle, WM_VSCROLL, SB_BOTTOM, 0); //�߰���ũ�� ���ϴ� �̵�
    PartialData:= '';
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

//���� �˾�â�� �ݰ� �ٽ� ��ĵŬ���ϰ� �ݺ��ϴ� ������������.
procedure TForm1.btnTriggerScanClick(Sender: TObject);
begin
  if ApdComPort1.Open then
  begin
    ApdComPort1.Output := #2;
    ShowMessage('��ĵ����� �����߽��ϴ�.');
  end
  else
    ShowMessage('��Ʈ�� �������� �ʽ��ϴ�.');
end;

end.
