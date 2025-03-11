unit uTruck1;

interface
Type
TTruck=class
Engine,Year:integer;
Color:string;
HasPack:boolean;
Constructor Create;
Destructor Destroy;
end;

implementation

Constructor TTruck.Create;
begin
 Engine:=3000;
 Year:=1998;
 Color:='Blue';
 HasPack:=true;
end;

Destructor TTruck.Destroy;
begin
end;
end.
