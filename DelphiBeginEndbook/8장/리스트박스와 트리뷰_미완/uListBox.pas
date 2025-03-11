unit uListBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure ListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



procedure TForm1.ListBox1Click(Sender: TObject);
if ListBox.SelCount<>0 then
begin
Button4.Enabled:=true;
Button5.Enabled:=true;
end;

procedure TForm1.Button1Click(Sender: TObject);
if Edit1.text <> " then
ListBox1.Items.Add(Edit1.text);

procedure TForm1.Button3Click(Sender: TObject);
ListBox1.Items.delete(ListBox1.ItemIndex);
procedure TForm1.Button4Click(Sender: TObject);
ListBox1.Clear
procedure TForm1.Button5Click(Sender: TObject);
if ListBox1.ItemIndex>0 then
ListBox1.Items.Move(ListBox1.ItemIndex, ListBox1.ItemIndex-1);
Button4.Enabled:=false;
Button5.Enabled:=false;

procedure TForm1.Button2Click(Sender: TObject);
if ListBox1.ItemIndex<ListBox1.Items.Count-1 then
ListBox1.Items.Move(ListBox1.ItemIndex, ListBox1.ItemIndex+1);
Button4.Enabled:=false;
Button5.Enabled:=false;

end.
