unit uBus2;

interface

uses uBaseCar; //상속하기위해 유닛포함

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
