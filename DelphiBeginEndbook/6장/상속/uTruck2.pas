unit uTruck2;

interface

uses uBaseCar ; //TBaseCar�� ����Ҽ� �ֱ����ؼ� uBaseCar ������ ���Խ��Ѿ��Ѵ�.

Type
TTruck2=class(TBaseCar)
 HasPack:boolean;
 constructor Create;
end;

implementation
constructor TTruck2.Create;
begin
 inherited Create;
 HasPack:=true;
end;

end.
