unit uTruck2;

interface

uses uBaseCar ; //TBaseCar을 상속할수 있기위해서 uBaseCar 유닛을 포함시켜야한다.

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
