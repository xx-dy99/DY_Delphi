unit uBus2;

interface

uses uBaseCar; //����ϱ����� ��������

Type
 TBus2=class(TBaseCar)
 HasPassanger:boolean;
 constructor Create; override; //�θ� Ŭ�������� virtual�� ����� �޼ҵ忡 ����
end;                           //�ڳ� Ŭ�������� override���� �ٿ��ش�.

implementation

constructor TBus2.Create;
begin
 inherited Create;//�θ�Ŭ������ �����ڸ� �����ϰڴٴ� �ǹ�.
 HasPassanger:=true;
end;

end.
