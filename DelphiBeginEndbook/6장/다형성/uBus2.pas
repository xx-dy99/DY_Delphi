unit uBus2;

interface

uses uBaseCar,Dialogs; //����ϱ����� ��������

Type
 TBus2=class(TBaseCar)
 HasPassanger:boolean;
 constructor Create;
 procedure Sound;override;
end;

implementation

constructor TBus2.Create;
begin
 inherited Create;//�θ�Ŭ������ �����ڸ� �����ϰڴٴ� �ǹ�.
 HasPassanger:=true;
end;

procedure TBus2.Sound;
begin
 showmessage('����!');
end;

end.
