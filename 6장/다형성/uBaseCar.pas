unit uBaseCar;

interface
Type
TBaseCar=class
 Engine,Year:integer;
 Color:string;
 constructor Create; virtual; //����Ⱥκ� virtual�̶�¿��� �����߰���
 procedure Sound;virtual;abstract;
end;

var
CarList:array[1..2] of TBaseCar;

implementation

constructor TBaseCar.Create;
begin
 Engine:=3000;
 Year:=1998;
 Color:='Red';
end;

end.
