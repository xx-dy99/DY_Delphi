unit uTruck2;

interface

uses uBaseCar ; //TBaseCar�� ����Ҽ� �ֱ����ؼ� uBaseCar ������ ���Խ��Ѿ��Ѵ�.

Type
TTruck2=class(TBaseCar)
 Engine,Year:integer;
 Color:string;
 HasPack:boolean;
 constructor Create;
end;

implementation

constructor TTruck2.Create;
begin
 Engine:=5000;
 Year:=1995;
 Color:='Blue';
 HasPack:=false;
end;

end.
