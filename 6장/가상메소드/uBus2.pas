unit uBus2;

interface

uses uBaseCar; //상속하기위해 유닛포함

Type
 TBus2=class(TBaseCar)
 HasPassanger:boolean;
 constructor Create; override; //부모 클래스에서 virtual로 선언된 메소드에 대해
end;                           //자녀 클래스에서 override예약어를 붙여준다.

implementation

constructor TBus2.Create;
begin
 inherited Create;//부모클래스의 생성자를 실행하겠다는 의미.
 HasPassanger:=true;
end;

end.
