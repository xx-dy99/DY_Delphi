unit uBus2;

interface

uses uBaseCar,Dialogs; //상속하기위해 유닛포함

Type
 TBus2=class(TBaseCar)
 HasPassanger:boolean;
 constructor Create;
 procedure Sound;override;
end;

implementation

constructor TBus2.Create;
begin
 inherited Create;//부모클래스의 생성자를 실행하겠다는 의미.
 HasPassanger:=true;
end;

procedure TBus2.Sound;
begin
 showmessage('빵빵!');
end;

end.
