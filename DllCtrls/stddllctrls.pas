unit StdDllCtrls;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdDllInterfaces, Controls, StdCtrls;

type
  TEGUIArea= class (TGroupBox,IEGUIArea)
  private
  protected
    function GetCaption: ShortString; stdcall;
    procedure SetCaption(const Value: ShortString); stdcall;
    function GetLeft: IEInt; stdcall;
    procedure SetLeft(const Value: IEInt); stdcall;
    function GetHeight: IEInt; stdcall;
    procedure SetHeight(const Value: IEInt); stdcall;
    function GetTop: IEInt, stdcall;
    procedure SetTop(const Value: IEInt); stdcall;
    function GetWidth: IEInt; stdcall;
    procedure SetWidth(const Value: IEInt); stdcall;
    function AddControl(const ControlType: TEControlType): IControl; stdcall;
    procedure RemoveControl(var Control: IControl); stdcall;
  end;

  TEButton = class (TButton,IEButton)
  protected
    function GetAnchors: TAnchors; stdcall;
    procedure SetAnchors(const Value: TAnchors); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetHeight: IEInt; stdcall;
    procedure SetHeight(const Value: IEInt); stdcall;
    function GetLeft: IEInt; stdcall;
    procedure SetLeft(const Value: IEInt); stdcall;
    function GetTabOrder: IEInt; stdcall;
    procedure SetTabOrder(const Value: IEInt); stdcall;
    function GetTop: IEInt; stdcall;
    procedure SetTop(const Value: IEInt); stdcall;
    function GetVisible: Boolean; stdcall;
    procedure SetVisible(const Value: Boolean); stdcall;
    function GetWidth: IEInt; stdcall;
    procedure SetWidth(const Value: IEInt); stdcall;

    function GetCaption: ShortString; stdcall;
    procedure SetCaption(const Value: ShortString); stdcall;
    function GetOnClick: TNotifyEvent; stdcall;
    procedure SetOnClick(const Value: TNotifyEvent); stdcall;
  end;

  TEEdit = class (TEdit,IEEdit)
  protected
    function GetAnchors: TAnchors; stdcall;
    procedure SetAnchors(const Value: TAnchors); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetHeight: IEInt; stdcall;
    procedure SetHeight(const Value: IEInt); stdcall;
    function GetLeft: IEInt; stdcall;
    procedure SetLeft(const Value: IEInt); stdcall;
    function GetTabOrder: IEInt; stdcall;
    procedure SetTabOrder(const Value: IEInt); stdcall;
    function GetTop: IEInt; stdcall;
    procedure SetTop(const Value: IEInt); stdcall;
    function GetVisible: Boolean; stdcall;
    procedure SetVisible(const Value: Boolean); stdcall;
    function GetWidth: IEInt; stdcall;
    procedure SetWidth(const Value: IEInt); stdcall;

    function GetAutoSelect: Boolean; stdcall;
    procedure SetAutoSelect(const Value: Boolean); stdcall;
    function GetMaxLength: IEInt; stdcall;
    procedure SetMaxLength(const Value: IEInt); stdcall;
    function GetPasswordChar: Char; stdcall;
    procedure SetPasswordChar(const Value: Char); stdcall;
    function GetReadOnly: Boolean; stdcall;
    procedure SetReadOnly(const Value: Boolean); stdcall;
    function GetText: ShortString; stdcall;
    procedure SetText(const Value: ShortString); stdcall;
    function GetOnChange: TNotifyEvent; stdcall;
    procedure SetOnChange(const Value: TNotifyEvent); stdcall;
    function GetOnClick: TNotifyEvent; stdcall;
    procedure SetOnClick(const Value: TNotifyEvent); stdcall;
    function GetOnDblClick: TNotifyEvent; stdcall;
    procedure SetOnDblClick(const Value: TNotifyEvent); stdcall;
    function GetOnEnter: TNotifyEvent; stdcall;
    procedure SetOnEnter(const Value: TNotifyEvent); stdcall;
    function GetOnExit: TNotifyEvent; stdcall;
    procedure SetOnExit(const Value: TNotifyEvent);
    function GetOnEditingDone: TNotifyEvent; stdcall;
    procedure SetOnEditingDone(const Value: TNotifyEvent); stdcall;
  end;

const
  ControlClasses   : array [IEControlType] of TControlClass = (TEButton,TEEdit);
  ControlInterfaces: array [IEControlType] of TControlClass = (TEButton,TEEdit);

procedure Register;

implementation

{TEGUIArea}

function TEGUIArea.GetCaption: ShortString; stdcall;
begin
  Result:=Caption;
end;

procedure TEGUIArea.SetCaption(const Value: ShortString); stdcall;
begin
  Caption:=Value;
end;

function TEGUIArea.GetLeft: IEInt; stdcall;
begin
  Result:=Left;
end;

procedure TEGUIArea.SetLeft(const Value: IEInt); stdcall;
begin
  Left:=Value;
end;

function TEGUIArea.GetHeight: IEInt; stdcall;
begin
  Result:=Height;
end;

procedure TEGUIArea.SetHeight(const Value: IEInt); stdcall;
begin
  Height:=Value;
end;

function TEGUIArea.GetTop: IEInt, stdcall;
begin
  Result:=Top;
end;

procedure TEGUIArea.SetTop(const Value: IEInt); stdcall;
begin
  Top:=Value;
end;

function TEGUIArea.GetWidth: IEInt; stdcall;
begin
  Result:=Width;
end;

procedure TEGUIArea.SetWidth(const Value: IEInt); stdcall;
begin
  Width:=Value;
end;

function TEGUIArea.AddControl(const ControlType: TEControlType): IControl; stdcall;
var
  ANewControl: TControl;
begin
  ANewControl:=ControlClasses[ControlType].Create;
  InsertControl(ANewControl);
  Result:=ANewControl;
end;

procedure TEGUIArea.RemoveControl(var Control: IControl); stdcall;
var
  AOldControl: TControl;
begin
  AOldControl:=Control;
  RemoveControl(AOldControl);
  AOldControl.Destroy;
  Control:=nil;
end;

{TEButton}

function TEButton.GetAnchors: TAnchors; stdcall;
begin
  Result:=Anchors;
end;

procedure TEButton.SetAnchors(const Value: TAnchors); stdcall;
begin
  Anchors:=Value;
end;

function TEButton.GetEnabled: Boolean; stdcall;
begin
  Result:=Enabled;
end;

procedure TEButton.SetEnabled(const Value: Boolean); stdcall;
begin
  Enabled:=Value;
end;

function TEButton.GetHeight: IEInt; stdcall;
begin
  Result:=Height;
end;

procedure TEButton.SetHeight(const Value: IEInt); stdcall;
begin
  Height:=Value;
end;

function TEButton.GetLeft: IEInt; stdcall;
begin
  Result:=Left;
end;

procedure TEButton.SetLeft(const Value: IEInt); stdcall;
begin
  Left:=Value;
end;

function TEButton.GetTabOrder: IEInt; stdcall;
begin
  Result:=TabOrder;
end;

procedure TEButton.SetTabOrder(const Value: IEInt); stdcall;
begin
  TabOrder:=Value;
end;

function TEButton.GetTop: IEInt; stdcall;
begin
  Result:=Top;
end;

procedure TEButton.SetTop(const Value: IEInt); stdcall;
begin
  Top:=Value;
end;

function TEButton.GetVisible: Boolean; stdcall;
begin
  Result:=Visible;
end;

procedure TEButton.SetVisible(const Value: Boolean); stdcall;
begin
  Visible:=Value;
end;

function TEButton.GetWidth: IEInt; stdcall;
begin
  Result:=Width;
end;

procedure TEButton.SetWidth(const Value: IEInt); stdcall;
begin
  Width:=Value;
end;

function TEButton.GetCaption: ShortString; stdcall;
begin
  Result:=Caption;
end;

procedure TEButton.SetCaption(const Value: ShortString); stdcall;
begin
  Caption:=Value;
end;

function TEButton.GetOnClick: TNotifyEvent; stdcall;
begin
  Result:=OnClick;
end;

procedure TEButton.SetOnClick(const Value: TNotifyEvent); stdcall;
begin
  OnClick:=Value;
end;

{TEEdit}

function TEEdit.GetAnchors: TAnchors; stdcall;
begin
  Result:=Anchors;
end;

procedure TEEdit.SetAnchors(const Value: TAnchors); stdcall;
begin
  Anchors:=Value;
end;

function TEEdit.GetEnabled: Boolean; stdcall;
begin
  Result:=Enabled;
end;

procedure TEEdit.SetEnabled(const Value: Boolean); stdcall;
begin
  Enabled:=Value;
end;

function TEEdit.GetHeight: IEInt; stdcall;
begin
  Result:=Height;
end;

procedure TEEdit.SetHeight(const Value: IEInt); stdcall;
begin
  Height:=Value;
end;

function TEEdit.GetLeft: IEInt; stdcall;
begin
  Result:=Left;
end;

procedure TEEdit.SetLeft(const Value: IEInt); stdcall;
begin
  Left:=Value;
end;

function TEEdit.GetTabOrder: IEInt; stdcall;
begin
  Result:=TabOrder;
end;

procedure TEEdit.SetTabOrder(const Value: IEInt); stdcall;
begin
  TabOrder:=Value;
end;

function TEEdit.GetTop: IEInt; stdcall;
begin
  Result:=Top;
end;

procedure TEEdit.SetTop(const Value: IEInt); stdcall;
begin
  Top:=Value;
end;

function TEEdit.GetVisible: Boolean; stdcall;
begin
  Result:=Visible;
end;

procedure TEEdit.SetVisible(const Value: Boolean); stdcall;
begin
  Visible:=Value;
end;

function TEEdit.GetWidth: IEInt; stdcall;
begin
  Result:=Width;
end;

procedure TEEdit.SetWidth(const Value: IEInt); stdcall;
begin
  Width:=Value;
end;

function TEEdit.GetAutoSelect: Boolean; stdcall;
begin
  Result:=AutoSelect;
end;

procedure TEEdit.SetAutoSelect(const Value: Boolean); stdcall;
begin
  AutoSelect:=Value;
end;

function TEEdit.GetMaxLength: IEInt; stdcall;
begin
  Result:=MaxLength;
end;

procedure TEEdit.SetMaxLength(const Value: IEInt); stdcall;
begin
  MaxLength:=Value;
end;

function TEEdit.GetPasswordChar: Char; stdcall;
begin
  Result:=PasswordChar;
end;

procedure TEEdit.SetPasswordChar(const Value: Char); stdcall;
begin
  PasswordChar:=Value;
end;

function TEEdit.GetReadOnly: Boolean; stdcall;
begin
  Result:=ReadOnly;
end;

procedure TEEdit.SetReadOnly(const Value: Boolean); stdcall;
begin
  ReadOnly:=Value;
end;

function TEEdit.GetText: ShortString; stdcall;
begin
  Result:=Text;
end;

procedure TEEdit.SetText(const Value: ShortString); stdcall;
begin
  Text:=Value;
end;

function TEEdit.GetOnChange: TNotifyEvent; stdcall;
begin
  Result:=OnChange;
end;

procedure TEEdit.SetOnChange(const Value: TNotifyEvent); stdcall;
begin
  OnChange:=Value;
end;

function TEEdit.GetOnClick: TNotifyEvent; stdcall;
begin
  Result:=OnClick;
end;

procedure TEEdit.SetOnClick(const Value: TNotifyEvent); stdcall;
begin
  OnClick:=Value;
end;

function TEEdit.GetOnDblClick: TNotifyEvent; stdcall;
begin
  Result:=OnDblClick;
end;

procedure TEEdit.SetOnDblClick(const Value: TNotifyEvent); stdcall;
begin
  OnDblClick:=Value;
end;

function TEEdit.GetOnEnter: TNotifyEvent; stdcall;
begin
  Result:=OnEnter;
end;

procedure TEEdit.SetOnEnter(const Value: TNotifyEvent); stdcall;
begin
  OnEnter:=Value;
end;

function TEEdit.GetOnExit: TNotifyEvent; stdcall;
begin
  Result:=OnExit;
end;

procedure TEEdit.SetOnExit(const Value: TNotifyEvent);
begin
  OnExit:=Value;
end;

function TEEdit.GetOnEditingDone: TNotifyEvent; stdcall;
begin
  Result:=OnEditingDone;
end;

procedure TEEdit.SetOnEditingDone(const Value: TNotifyEvent); stdcall;
begin
  OnEditingDone:=Value;
end;

{Allgemein}

procedure Register;
begin
  //RegisterComponents('Interfaced Controls',[TEButton]);
end;

end.

