unit uMainMenu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, Menus, ComCtrls, ToolWin, StdActns, ActnList;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    N1: TMenuItem;
    Open1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ImageList1: TImageList;
    ActionList1: TActionList;
    EditCopy1: TEditCopy;
    EditCut1: TEditCut;
    EditDelete1: TEditDelete;
    ActionList2: TActionList;
    NewAction: TAction;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    copy1: TMenuItem;
    paste1: TMenuItem;
    PopupMenu1: TPopupMenu;
    New2: TMenuItem;
    procedure NewActionExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.NewActionExecute(Sender: TObject);
begin
 Showmessage('NewAction ½ÇÇà!');
end;

end.
