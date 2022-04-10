unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, MaskEdit, LCLIntf,
  Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonRefreshWindows: TButton;
    ButtonMoveWindow: TButton;
    edtTop: TEdit;
    edtLeft: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBoxWindows: TListBox;
    procedure ButtonMoveWindowClick(Sender: TObject);
    procedure ButtonRefreshWindowsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

function EnumWindowsProc(WHandle: HWND; LParM: LParam): LongBool;StdCall;Export;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
     ListBoxWindows.Items.Clear();
     EnumWindows(@EnumWindowsProc,0);
end;

procedure TForm1.Label4Click(Sender: TObject);
begin
  OpenUrl('https://ekiwi-blog.de');
end;

procedure TForm1.ButtonMoveWindowClick(Sender: TObject);
var
   MyHandle: THandle;
   WinRect: TRect;
   windowTitle : string;
   x,y : Integer;
begin
  windowTitle:= ListBoxWindows.Items[ListBoxWindows.ItemIndex];
  if windowTitle = '' then
  begin
     ShowMessage('Please select a window');

  end else begin
      try
         x:= StrToInt(edtLeft.Text);
         y:= StrToInt(edtTop.Text);
      except
         ShowMessage('Please enter numbers only');
      end;
    end;

    MyHandle:=FindWindow(nil, PChar(windowTitle));
    GetWindowRect(MyHandle, WinRect);
    MoveWindow(MyHandle, x, y, WinRect.Width, WinRect.Height, True);
end;

procedure TForm1.ButtonRefreshWindowsClick(Sender: TObject);
begin
 ListBoxWindows.Items.Clear();
 EnumWindows(@EnumWindowsProc,0);
end;

function EnumWindowsProc(WHandle: HWND; LParM: LParam): LongBool;StdCall;Export;
var Title,ClassName:array[0..128] of char;
    sTitle,sClass,Linia:STRING ;

begin
 Result:=True;

 GetWindowText(wHandle, Title,128);
 GetClassName(wHandle, ClassName,128);

 sTitle:=Title;
 sClass:=ClassName;

 if IsWindowVisible(wHandle) then
 begin
  Linia:=sTitle; //+'        '+sClass+'       '+IntToHex(wHandle,4);
  if Linia <> '' then Form1.ListBoxWindows.Items.Add(Linia);
 end;
end;

end.

