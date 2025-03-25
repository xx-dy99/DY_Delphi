unit uBarcode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, OoMisc, AdPort, AdPacket;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Memo1: TMemo;
    btnPortOpen: TButton;
    btnPortClose: TButton;
    btnTriggerScan: TButton;
    ApdDataPacket1: TApdDataPacket;
    procedure btnPortOpenClick(Sender: TObject);
    procedure btnPortCloseClick(Sender: TObject);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTriggerScanClick(Sender: TObject);
    procedure ApdDataPacket1StringPacket(Sender: TObject; Data: AnsiString);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  //���� PartialData: string = '';
  PartialData: AnsiString = '';
  DataStr : AnsiString; //���������͸� ������ ���ڿ� �������� AnsiString���� ����

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
    on E : Exception do //����(����)�� ��Ƽ� E��� ������ �����ϰ� �����޽��� Ȯ��.
      ShowMessage('��Ʈ ���� ����:' + E.Message);
  end;
end;

procedure TForm1.ApdDataPacket1StringPacket(Sender: TObject; Data: AnsiString);
var
  len : word; //len�� word�� ���� word = 2byte
begin
  exit;
  len := Length(data); // len�� data�� ���̸� ����
  Memo1.Lines.Add(Data + '('+ InttoStr(len) +')' );
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
  ReceivedData: array[0..255] of char;
  I : Integer; //�߰� , �ݺ������� ����� ����
  ch : AnsiChar;
  str : AnsiString;
begin

  for i := 1 to count do begin // i�� 1�� �ʱ�ȭ�ϰ� count���� ����

     ch := ApdComPort1.GetChar;
     DataStr := DataStr + ch;
  end;

  if Length(DataStr) <> 11 then exit;

  str := DataStr + Format('(length:%d)', [Length(DataStr)]);
  Memo1.Lines.Add(DataStr + str);

  exit;
  FillChar(ReceivedData, Sizeof(ReceivedData), 0); //ReceivedData 0���� �ʱ�ȭ
  ApdComPort1.GetBlock(ReceivedData, Count); //���������͸� ReceivedData�� ����

  //�߰� ����Ʈ �����͸� AnsiString���� ��ȯ
  //SetLength(DataStr, Count);
  for I := 0 to Count - 1 do
    DataStr:= DataStr + AnsiChar(ReceivedData[I]);

  if Length(DataStr) <> 11 then exit;
  

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
  //if Length(PartialData) < 8 then Exit;

  if (Pos(#13, DataStr) > 0) or (Pos(#10, DataStr) > 0) then
  begin
    //���� Memo1.Lines.Add(PartialData);
    Memo1.Lines.Add(string(PartialData));//�߰� AnsiString�� Unicode�κ�ȯ�� Memo1�� �߰�
    Memo1.SelStart := Length(Memo1.Text); //�ڵ���ũ�� �̵�
    SendMessage(Memo1.Handle, WM_VSCROLL, SB_BOTTOM, 0); //�߰���ũ�� ���ϴ� �̵�
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
  // ���� (����)DataStr := StrPas(ReceivedData);
  if ApdComPort1.Open then
  begin
    DataStr := '';
    ApdComPort1.FlushInBuffer;
    ApdComPort1.FlushOutBuffer;

    ApdComPort1.Output := #2;
    //ShowMessage('��ĵ����� �����߽��ϴ�.');
  end
  else
    ShowMessage('��Ʈ�� �������� �ʽ��ϴ�.');
end;

end.
