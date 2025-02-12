unit Rainbow;

interface

uses
  Windows, Classes, SysUtils, ExtCtrls;

type
  TRainbow = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override; //이걸한번 재정립해줘야함 실행이되는곳 Excute는 약간 따로 노는곳.
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

procedure TRainbow.Execute;//Thread가 여기서 실행이됨.(excute)
begin
  repeat
     if Shape <> nil then
      Shape.Brush.Color:=
       Round(Random(256)) shl 16 +
       Round(Random(256)) shl 8 +
       Round(Random(256));
     Sleep(1);  //CPU를 다잡아먹지 않게 중간중간 쉬어줌.
  until Self.Terminated = true;
end;

end.
