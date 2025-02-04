unit uBus1;

interface

Type
TBus=class
Engine,Year:integer;
Color:String;
HasPassanger:boolean;
constructor Create;
Destructor Destroy;
end;

implementation

Constructor TBus.Create;
begin
 Engine:=5000;
 Year:=1998;
 Color:='Yellow';
 HasPassanger:=false;
end;

Destructor TBus.Destroy;
begin
end;

end.
