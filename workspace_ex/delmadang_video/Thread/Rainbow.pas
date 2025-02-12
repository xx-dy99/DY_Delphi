unit Rainbow;

interface

uses
  Windows, Classes, SysUtils, ExtCtrls;

type
  TRainbow = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override; //�̰��ѹ� ������������� �����̵Ǵ°� Excute�� �ణ ���� ��°�.
  public
    Shape : TShape;
  end;

implementation

{ Important: Methods and properties of objects in VCL can only be used in a
  method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure Rainbow.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ Rainbow }

procedure TRainbow.Execute;//Thread�� ���⼭ �����̵�.(excute)
begin
  repeat
     if Shape <> nil then
      Shape.Brush.Color:=
       Round(Random(256)) shl 16 +
       Round(Random(256)) shl 8 +
       Round(Random(256));
     Sleep(1);  //CPU�� ����Ƹ��� �ʰ� �߰��߰� ������.
  until Self.Terminated = true;
end;

end.
