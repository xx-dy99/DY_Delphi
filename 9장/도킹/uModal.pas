unit uModal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls;

type
  TfrmModal = class(TForm)
    Button1: TButton;
    BitBtn1: TBitBtn;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmModal: TfrmModal;

implementation

{$R *.DFM}

procedure TfrmModal.Button1Click(Sender: TObject);
begin
 ModalResult:=mrOk;
end;

end.
