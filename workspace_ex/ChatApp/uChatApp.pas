unit uChatApp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    btnStartServer: TButton;
    btnStartClient: TButton;
    edtServerIp: TEdit;
    RichEditChat: TRichEdit;
    edtNickname: TEdit;
    edtMessage: TEdit;
    btnSend: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnNickname: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
