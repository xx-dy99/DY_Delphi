unit uBus2;

interface

uses uBaseCar; //����ϱ����� ��������

Type
TBus2=class(TBaseCar)
 HasPassanger:boolean;
 constructor Create;
end;

implementation

constructor TBus2.Create;
begin
 inherited Create;
 HasPassanger:=true;
end;

end.
