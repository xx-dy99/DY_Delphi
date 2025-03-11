unit uBaseCar;

interface
Type
TBaseCar=class
 Engine,Year:integer;
 Color:string;
 constructor Create; virtual; //변경된부분 virtual이라는예약어가 새로추가됨
end;

implementation

constructor TBaseCar.Create;
begin
 Engine:=3000;
 Year:=1998;
 Color:='Red';
end;

end.
