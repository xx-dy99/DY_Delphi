unit uTruck2;

interface

uses uBaseCar,Dialogs ; //TBaseCar�� ����Ҽ� �ֱ����ؼ� uBaseCar ������ ���Խ��Ѿ��Ѵ�.

Type
TTruck2=class(TBaseCar)
 HasPack:boolean;
 constructor Create;override;
 procedure Sound;override;
end;

implementation

constructor TTruck2.Create;
begin
 inherited Create;
 HasPack:=false;
end;

procedure TTruck2.Sound;
begin
 showmessage('���!');
end;

end.
