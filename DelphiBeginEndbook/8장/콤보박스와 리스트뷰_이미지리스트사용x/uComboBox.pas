unit uComboBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ImgList, StdCtrls;

type
  TfrmListView = class(TForm)
    ComboBox1: TComboBox;
    ImageList1: TImageList;
    ListView1: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmListView: TfrmListView;

implementation

{$R *.DFM}

end.
