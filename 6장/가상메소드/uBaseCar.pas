unit uBaseCar;

interface
Type
TBaseCar=class
 Engine,Year:integer;
 Color:string;
 constructor Create; virtual; //����Ⱥκ� virtual�̶�¿��� �����߰���
end;

implementation

constructor TBaseCar.Create;
begin
 Engine:=3000;
 Year:=1998;
 Color:='Red';
end;

end.
