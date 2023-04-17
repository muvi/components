unit StdDllInterfaces; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls;

type
  IEInt        = LongInt;
  IEControlTYpe= (ectButton = 0,ectEdit = 1);

  IEControl    = interface
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

    property Anchors: TAnchors read GetAnchors write SetAnchors;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Height: IEInt read GetHeight write SetHeight;
    property Left: IEInt read GetLeft write SetLeft;
    property TabOrder: IEInt read GetTabOrder write SetTabOrder;
    property Top: IEInt read GetTop write SetTop;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  IEGUIArea    = interface
    ['{3B31D5A2-3EF5-433D-9FDA-358E9BB26824}']
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
    procedure RemoveControl(const Control: IControl); stdcall;

    property Caption: SHortString read GetCaption write SetCaption;
    property Left: IEInt read GetLeft write SetLeft;
    property Height: IEInt read GetHEight write SetHeight;
    property Top: IEInt read GetTop write SetTop;
    property Width: IEInt read GetWidth write SetWidth;
  end;

  //IEControlType= interface of IEControl;

  IEButton     = interface (IEControl)
    ['{D7C87EF5-89AB-46AF-9FF0-8FD309F1F2E6}']
    function GetCaption: ShortString; stdcall;
    procedure SetCaption(const Value: ShortString); stdcall;
    function GetOnClick: TNotifyEvent; stdcall;
    procedure SetOnClick(const Value: TNotifyEvent); stdcall;

    property Caption: ShortString read GetCaption write SetCaption;
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
  end;

  IEEdit       = interface (IEControl)
    ['{D9F17B9E-1739-4F0B-9CC1-0E3B4C1C1594}']
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

    property AutoSelect: Boolean read GetAutoSelect write SetAutoSelect;
    property MaxLength: IEInt read GetMaxLength write SetMaxLength;
    property PasswordChar: Char read GetPasswordChar write SetPasswordChar;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property Text: ShortString read GetText write SetText;
    property OnChange: TNotifyEvent read GetOnChange write SetOnChange;
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
    property OnDblClick: TNotifyEvent read GetOnDblClick write SetOnDblClick;
    property OnEnter: TNotifyEvent read GetOnEnter write SetOnEnter;
    property OnExit: TNotifyEvent read GetOnExit write SetOnExit;
    property OnEditingDone: TNotifyEvent read GetOnEditingDone write SetOnEditingDone;
  end;

implementation

end.

