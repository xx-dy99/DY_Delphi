unit uModuless;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmModeless = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmModeless: TfrmModeless;

implementation

uses Unit1, Unit2;

{$R *.DFM}

procedure TfrmModeless.Button1Click(Sender: TObject);
begin
 Edit1.Text:=MainForm.Caption;
end;

procedure TfrmModeless.Button2Click(Sender: TObject);
begin
 close;
end;

procedure TfrmModeless.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;

end.
