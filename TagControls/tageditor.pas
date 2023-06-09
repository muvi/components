unit TagEditor;

{$MODE Delphi}

interface

uses
  LMessages, SysUtils, Classes, Controls, StdCtrls, Forms, Graphics, LCLIntf,
  Menus, LCLType, Math, Clipbrd;

type
  TClickInfo = cardinal;
  GetTagIndex = word;

const TAG_LOW = 0;
const TAG_HIGH = MAXWORD - 2;
const EDITOR = MAXWORD - 1;
const NOWHERE = MAXWORD;

const PART_BODY = $00000000;
const PART_REMOVE_BUTTON = $00010000;

function GetTagPart(ClickInfo: TClickInfo): cardinal;

type
  TTagClickEvent = procedure(Sender: TObject; TagIndex: integer;
    const TagCaption: string) of object;
  TRemoveConfirmEvent = procedure(Sender: TObject; TagIndex: integer;
    const TagCaption: string; var CanRemove: boolean) of object;
  TTagEditor = class(TCustomControl)
  private
    { Private declarations }
    FTags: TStringList;
    FEdit: TEdit;
    FBgColor: TColor;
    FBorderColor: TColor;
    FTagBgColor: TColor;
    FTagBorderColor: TColor;
    FSpacing: integer;
    FTextColor: TColor;
    FLefts, FRights, FWidths,
    FTops, FBottoms: array of integer;
    FCloseBtnLefts, FCloseBtnTops: array of integer;
    FCloseBtnWidth: integer;
    FSpaceAccepts: boolean;
    FCommaAccepts: boolean;
    FSemicolonAccepts: boolean;
    FTrimInput: boolean;
    FNoLeadingSpaceInput: boolean;
    FTagClickEvent: TTagClickEvent;
    FAllowDuplicates: boolean;
    FPopupMenu: TPopupMenu;
    FMultiLine: boolean;
    FTagHeight: integer;
    FEditPos: TPoint;
    FActualTagHeight: integer;
    FShrunk: boolean;
    FEditorColor: TColor;
    FTagAdded: TNotifyEvent;
    FTagRemoved: TNotifyEvent;
    FOnChange: TNotifyEvent;
    FOnRemoveConfirm: TRemoveConfirmEvent;
    FMouseDownClickInfo: TClickInfo;
    FCaretVisible: boolean;
    FDragging: boolean;
    FAutoHeight: boolean;
    FNumRows: integer;
    FMaxHeight: integer;
    FDesiredHeight: integer;
    FScrollInfo: TScrollInfo;
    FPrevScrollPos: integer;
    FScrollBarVisible: Boolean;
    procedure SetBorderColor(const Value: TColor);
    procedure SetTagBgColor(const Value: TColor);
    procedure SetTagBorderColor(const Value: TColor);
    procedure SetSpacing(const Value: integer);
    procedure TagChange(Sender: TObject);
    procedure SetTags(const Value: TStringList);
    procedure SetTextColor(const Value: TColor);
    procedure ShowEditor;
    procedure HideEditor;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure mnuDeleteItemClick(Sender: TObject);
    procedure SetMultiLine(const Value: boolean);
    procedure SetTagHeight(const Value: integer);
    procedure EditExit(Sender: TObject);
    function Accept: boolean;
    procedure SetBgColor(const Value: TColor);
    function GetClickInfoAt(X, Y: integer): TClickInfo;
    function GetSeparatorIndexAt(X, Y: integer): integer;
    procedure CreateCaret;
    procedure DestroyCaret;
    function IsFirstOnRow(TagIndex: integer): boolean; inline;
    function IsLastOnRow(TagIndex: integer): boolean;
    procedure SetAutoHeight(const Value: boolean);
    procedure SetMaxHeight(const Value: integer);
    procedure UpdateMetrics;
    procedure UpdateScrollBars;
    procedure DrawFocusRect;
    function GetShrunkClientRect(const Amount: integer): TRect;
    procedure FixPosAndScrollWindow;
    procedure EditEnter(Sender: TObject);
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;

    procedure KeyPress(var Key: Char); override;
    procedure WndProc(var Message: TLMessage); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property TabOrder;
    property TabStop;
    property Color;
    property Anchors;
    property Align;
    property Tag;
    property Cursor;
    property BgColor: TColor read FBgColor write SetBgColor;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property TagBgColor: TColor read FTagBgColor write SetTagBgColor;
    property TagBorderColor: TColor read FTagBorderColor
      write SetTagBorderColor;
    property Spacing: integer read FSpacing write SetSpacing;
    property Tags: TStringList read FTags write SetTags;
    property TextColor: TColor read FTextColor write SetTextColor;
    property SpaceAccepts: boolean read FSpaceAccepts write FSpaceAccepts
      default true;
    property CommaAccepts: boolean read FCommaAccepts write FCommaAccepts
      default true;
    property SemicolonAccepts: boolean read FSemicolonAccepts
      write FSemicolonAccepts default true;
    property TrimInput: boolean read FTrimInput write FTrimInput default true;
    property NoLeadingSpaceInput: boolean read FNoLeadingSpaceInput
      write FNoLeadingSpaceInput default true;
    property AllowDuplicates: boolean read FAllowDuplicates write FAllowDuplicates
      default false;
    property MultiLine: boolean read FMultiLine write SetMultiLine default false;
    property TagHeight: integer read FTagHeight write SetTagHeight default 32;
    property EditorColor: TColor read FEditorColor write FEditorColor
      default clWindow;
    property AutoHeight: boolean read FAutoHeight write SetAutoHeight;
    property MaxHeight: integer read FMaxHeight write SetMaxHeight default 512;
    property OnTagClick: TTagClickEvent read FTagClickEvent write FTagClickEvent;
    property OnTagAdded: TNotifyEvent read FTagAdded write FTagAdded;
    property OnTagRemoved: TNotifyEvent read FTagRemoved write FTagRemoved;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnRemoveConfirm: TRemoveConfirmEvent read FOnRemoveConfirm
      write FOnRemoveConfirm;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Rejbrand 2009', [TTagEditor]);
end;

function IsKeyDown(const VK: integer): boolean;
begin
  IsKeyDown := GetKeyState(VK) and $8000 <> 0;
end;

function GetTagPart(ClickInfo: TClickInfo): cardinal;
begin
  result := ClickInfo and $FFFF0000;
end;

procedure SafeDrawFocusRect(hDC: HDC; const R: TRect);
var
  oldBkColor, oldTextColor: COLORREF;
begin
  oldBkColor := LCLIntf.SetBkColor(hDC, clWhite);
  oldTextColor := LCLIntf.SetTextColor(hDC, clBlack);
  LCLIntf.DrawFocusRect(hDC, R);
  if oldBkColor <> CLR_INVALID then
    LCLIntf.SetBkColor(hDC, oldBkColor);
  if oldTextColor <> CLR_INVALID then
    LCLIntf.SetTextColor(hDC, oldTextColor);
end;

{ TTagEditor }

constructor TTagEditor.Create(AOwner: TComponent);
var
  mnuItem: TMenuItem;
begin
  inherited;
  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.BorderStyle := bsNone;
  FEdit.Visible := false;
  FEdit.OnKeyPress := EditKeyPress;
  FEdit.OnEnter := EditEnter;
  FEdit.OnExit := EditExit;

  FTags := TStringList.Create;
  FTags.OnChange := TagChange;

  FBgColor := clWindow;
  FBorderColor := clWindowFrame;
  FTagBgColor := clSkyBlue;
  FTagBorderColor := clNavy;
  FSpacing := 8;
  FTextColor := clWhite;
  FSpaceAccepts := true;
  FCommaAccepts := true;
  FSemicolonAccepts := true;
  FTrimInput := true;
  FNoLeadingSpaceInput := true;
  FAllowDuplicates := false;
  FMultiLine := false;
  FTagHeight := 32;
  FShrunk := false;
  FEditorColor := clWindow;
  FMaxHeight := 512;
  FCaretVisible := false;
  FDragging := false;
  FPrevScrollPos := 0;
  FScrollInfo.cbSize := sizeof(FScrollInfo);
  FScrollBarVisible := false;

  FPopupMenu := TPopupMenu.Create(Self);
  mnuItem := TMenuItem.Create(PopupMenu);
  mnuItem.Caption := 'Delete';
  mnuItem.OnClick := mnuDeleteItemClick;
  mnuItem.Hint := 'Deletes the selected tag.';
  FPopupMenu.Items.Add(mnuItem);

  TabStop := true;
end;

procedure TTagEditor.EditEnter(Sender: TObject);
begin
  if FEditPos.Y + FEdit.Height > FScrollInfo.nPos + ClientHeight then
    FScrollInfo.nPos := FEditPos.Y + ClientHeight - FEdit.Height;
  FixPosAndScrollWindow;
end;

procedure TTagEditor.EditExit(Sender: TObject);
begin
  if FEdit.Text <> '' then
    Accept
  else
    HideEditor;
end;

procedure TTagEditor.mnuDeleteItemClick(Sender: TObject);
var
  ACanRemove: Boolean;
  AIndex    : Integer;
begin
  AIndex:=TMenuItem(Sender).Tag;
  if Assigned(FOnRemoveConfirm) then begin
    ACanRemove:=false;
    FOnRemoveConfirm(Self, AIndex, FTags[AIndex], ACanRemove);
    if not ACanRemove then Exit;
  end;
  FTags.Delete(AIndex);
  if Assigned(FTagRemoved) then
    FTagRemoved(Self);
end;

procedure TTagEditor.TagChange(Sender: TObject);
begin
  UpdateMetrics;
  Invalidate;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TTagEditor.WndProc(var Message: TLMessage);
begin
  inherited;
  case Message.Msg of
    LM_SETFOCUS:
      Invalidate;
    LM_KILLFOCUS:
      begin
        if FCaretVisible then DestroyCaret;
        FDragging := false;
        Invalidate;
      end;
    LM_COPY:
      Clipboard.AsText := FTags.DelimitedText;
    LM_CLEAR:
      FTags.Clear;
    LM_CUT:
      begin
        Clipboard.AsText := FTags.DelimitedText;
        FTags.Clear;
      end;
    LM_PASTE:
      begin
        if Clipboard.HasFormat(CF_TEXT) then
          if FTags.Count = 0 then
            FTags.DelimitedText := Clipboard.AsText
          else
            FTags.DelimitedText := FTags.DelimitedText + ',' + Clipboard.AsText;
      end;
    LM_SIZE:
      begin
        UpdateMetrics;
        Invalidate;
        Message.Result := 0;
      end;
    LM_VSCROLL:
      begin
        FScrollInfo.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_VERT, FScrollInfo);
        case Message.WParamLo of
          SB_TOP:
            FScrollInfo.nPos := FScrollInfo.nMin;
          SB_BOTTOM:
            FScrollInfo.nPos := FScrollInfo.nMax;
          SB_PAGEUP:
            Dec(FScrollInfo.nPos, FScrollInfo.nPage);
          SB_PAGEDOWN:
            Inc(FScrollInfo.nPos, FScrollInfo.nPage);
          SB_LINEUP:
            Dec(FScrollInfo.nPos, FTagHeight);
          SB_LINEDOWN:
            Inc(FScrollInfo.nPos, FTagHeight);
          SB_THUMBTRACK:
            FScrollInfo.nPos := FScrollInfo.nTrackPos;
        end;

        FixPosAndScrollWindow;
        Message.Result := 0;

      end;
  end;
end;

procedure TTagEditor.FixPosAndScrollWindow;
var
  ARect: TRect;
begin
  FScrollInfo.fMask := SIF_POS;
  SetScrollInfo(Handle, SB_VERT, FScrollInfo, true);
  GetScrollInfo(Handle, SB_VERT, FScrollInfo);

  if FScrollInfo.nPos <> FPrevScrollPos then
  begin
    ARect:=GetShrunkClientRect(3);
    ScrollWindowEx(Handle, 0, FPrevScrollPos - FScrollInfo.nPos,
      @ARect, @ARect, 0, nil,
      SW_INVALIDATE);
    FPrevScrollPos := FScrollInfo.nPos;
    Update;
  end;
end;

procedure TTagEditor.UpdateScrollBars;
begin
  FScrollInfo.fMask := SIF_RANGE or SIF_PAGE;
  FScrollInfo.nMin := 0;
  FScrollInfo.nMax := FDesiredHeight - 1;
  FScrollInfo.nPage := ClientHeight;
  SetScrollInfo(Handle, SB_VERT, FScrollInfo, true);
  FixPosAndScrollWindow;
end;

function TTagEditor.Accept: boolean;
begin
  Assert(FEdit.Visible);
  result := false;
  if FTrimInput then
    FEdit.Text := Trim(FEdit.Text);
  if (FEdit.Text = '') or
    ((not AllowDuplicates) and (FTags.IndexOf(FEdit.Text) <> -1))  then
  begin
    beep;
    Exit;
  end;
  FTags.Add(FEdit.Text);
  result := true;
  HideEditor;
  if Assigned(FTagAdded) then
    FTagAdded(Self);
  Invalidate;
end;

procedure TTagEditor.EditKeyPress(Sender: TObject; var Key: Char);
var
  ACanRemove: Boolean;
begin
  if (Key = chr(VK_SPACE)) and (FEdit.Text = '') and FNoLeadingSpaceInput then begin
    Key := #0;
    Exit;
  end;
  if ((Key = chr(VK_SPACE)) and FSpaceAccepts) or
    ((Key = ',') and FCommaAccepts) or
    ((Key = ';') and FSemicolonAccepts) then
    Key := chr(VK_RETURN);

  case ord(Key) of
    VK_RETURN:
      begin
        Accept;
        ShowEditor;
        Key := #0;
      end;
    VK_BACK:
      begin
        if (FEdit.Text = '') and (FTags.Count > 0) then begin
          if Assigned(FOnRemoveConfirm) then begin
            ACanRemove:=false;
            FOnRemoveConfirm(Self, FTags.Count-1, FTags[FTags.Count-1], ACanRemove);
            if not ACanRemove then Exit;
          end;
          FTags.Delete(FTags.Count - 1);
          if Assigned(FTagRemoved) then
            FTagRemoved(Sender);
        end;
      end;
    VK_ESCAPE:
      begin
        HideEditor;
        Self.SetFocus;
        Key := #0;
      end;
  end;
end;

destructor TTagEditor.Destroy;
begin
  FPopupMenu.Free;
  FTags.Free;
  FEdit.Free;
  inherited;
end;

procedure TTagEditor.HideEditor;
begin
  FEdit.Text := '';
  FEdit.Hide;
//  SetFocus;
end;


procedure TTagEditor.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_END:
      ShowEditor;
    VK_DELETE:
      Perform(LM_CLEAR, 0, 0);
    VK_INSERT:
      Perform(LM_PASTE, 0, 0);
  end;
end;

procedure TTagEditor.KeyPress(var Key: Char);
begin
  inherited;

  case Key of
    ^C:
      begin
        Perform(LM_COPY, 0, 0);
        Key := #0;
        Exit;
      end;
    ^X:
      begin
        Perform(LM_CUT, 0, 0);
        Key := #0;
        Exit;
      end;
    ^V:
      begin
        Perform(LM_PASTE, 0, 0);
        Key := #0;
        Exit;
      end;
  end;

  ShowEditor;
  FEdit.Perform(LM_CHAR, ord(Key), 0);
end;

procedure TTagEditor.Loaded;
begin
  inherited;
  UpdateMetrics; // unfortunately, WM_SIZE is sent BEFORE the properties
                 // are loaded.
end;

function TTagEditor.GetClickInfoAt(X, Y: integer): TClickInfo;
var
  i: integer;
begin
  result := NOWHERE;
  if (X >= FEditPos.X) and (Y >= FEditPos.Y) then
    Exit(EDITOR);

  for i := 0 to FTags.Count - 1 do
    if InRange(X, FLefts[i], FRights[i]) and InRange(Y, FTops[i], FBottoms[i]) then
    begin
      result := i;
      if InRange(X, FCloseBtnLefts[i], FCloseBtnLefts[i] + FCloseBtnWidth) and
        InRange(Y, FCloseBtnTops[i], FCloseBtnTops[i] + FActualTagHeight) and
        not FShrunk then
        result := result or PART_REMOVE_BUTTON;
      break;
    end;
end;

function TTagEditor.IsFirstOnRow(TagIndex: integer): boolean;
begin
  result := (TagIndex = 0) or (FTops[TagIndex] > FTops[TagIndex-1]);
end;

function TTagEditor.IsLastOnRow(TagIndex: integer): boolean;
begin
  result := (TagIndex = FTags.Count - 1) or (FTops[TagIndex] < FTops[TagIndex+1]);
end;

function TTagEditor.GetSeparatorIndexAt(X, Y: integer): integer;
var
  i: Integer;
begin
  result := FTags.Count;
  Y := Max(Y, FSpacing + 1);
  for i := FTags.Count - 1 downto 0 do
  begin
    if Y < FTops[i] then Continue;
    if (IsLastOnRow(i) and (X >= FRights[i])) or
      ((X < FRights[i]) and (IsFirstOnRow(i) or (FRights[i-1] < X))) then
    begin
      result := i;
      if (IsLastOnRow(i) and (X >= FRights[i])) then inc(result);
      Exit;
    end;
  end;
end;

procedure TTagEditor.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inc(Y, FScrollInfo.nPos);
  FMouseDownClickInfo := GetClickInfoAt(X, Y);
  if GetTagIndex(FMouseDownClickInfo) <> EDITOR then
    SetFocus;
end;

procedure TTagEditor.CreateCaret;
begin
  if not FCaretVisible then
    FCaretVisible := LCLIntf.CreateCaret(Handle, 0, 0, FActualTagHeight);
end;

procedure TTagEditor.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or WS_VSCROLL;
end;

procedure TTagEditor.DestroyCaret;
begin
  if not FCaretVisible then Exit;
  LCLIntf.DestroyCaret(Handle);
  FCaretVisible := false;
end;

procedure TTagEditor.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  SepIndex: integer;
begin
  inherited;

  inc(Y, FScrollInfo.nPos);

  if IsKeyDown(VK_LBUTTON) and
    InRange(GetTagIndex(FMouseDownClickInfo), TAG_LOW, TAG_HIGH) then
  begin
    FDragging := true;
    Screen.Cursor := crDrag;
    SepIndex := GetSeparatorIndexAt(X, Y);
    CreateCaret;
    if SepIndex = FTags.Count then
      SetCaretPos(FLefts[SepIndex - 1] + FWidths[SepIndex - 1] + FSpacing div 2,
        FTops[SepIndex - 1] - FScrollInfo.nPos)
    else
      SetCaretPos(FLefts[SepIndex] - FSpacing div 2,
        FTops[SepIndex] - FScrollInfo.nPos);
    ShowCaret(Handle);
    Exit;
  end;

  case GetTagIndex(GetClickInfoAt(X,Y)) of
    NOWHERE: Cursor := crArrow;
    EDITOR: Cursor := crIBeam;
    TAG_LOW..TAG_HIGH: Cursor := crHandPoint;
  end;

end;

procedure TTagEditor.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  pnt: TPoint;
  CanRemove: boolean;
  ClickInfo: TClickInfo;
  i: word;
  p: cardinal;
  SepIndex: integer;
begin
  inherited;

  inc(Y, FScrollInfo.nPos);

  if FDragging then
  begin
    DestroyCaret;
    FDragging := false;
    Screen.Cursor := crDefault;
    SepIndex := GetSeparatorIndexAt(X, Y);
    if not InRange(SepIndex, GetTagIndex(FMouseDownClickInfo),
      GetTagIndex(FMouseDownClickInfo) + 1) then
      FTags.Move(GetTagIndex(FMouseDownClickInfo), SepIndex -
        IfThen(SepIndex > GetTagIndex(FMouseDownClickInfo), 1, 0));
    Exit;
  end;

  ClickInfo := GetClickInfoAt(X, Y);

  if ClickInfo <> FMouseDownClickInfo then Exit;

  i := GetTagIndex(ClickInfo);
  p := GetTagPart(ClickInfo);

  case i of
    EDITOR:
      ShowEditor;
    NOWHERE: ;
  else
    case Button of
      mbLeft:
        begin
          case p of
            PART_BODY:
              if Assigned(FTagClickEvent) then
                FTagClickEvent(Self, i, FTags[i]);
            PART_REMOVE_BUTTON:
              begin
                if Assigned(FOnRemoveConfirm) then
                begin
                  CanRemove := false;
                  FOnRemoveConfirm(Self, i, FTags[i], CanRemove);
                  if not CanRemove then Exit;
                end;
                FTags.Delete(i);
                if Assigned(FTagRemoved) then
                  FTagRemoved(Self);
              end;
          end;
        end;
      mbRight:
        begin
          FPopupMenu.Items[0].Tag := i;
          pnt := ClientToScreen(Point(X,Y));
          FPopupMenu.Items[0].Caption := 'Delete tag "' + FTags[i] + '"';
          FPopupMenu.Popup(pnt.X, pnt.Y - FScrollInfo.nPos);
        end;
    end;
  end;

end;

procedure TTagEditor.UpdateMetrics;
var
  i: integer;
  x, y: integer;
  MeanWidth: integer;
  AdjustedFDesiredHeight: integer;
begin

  SetLength(FLefts, FTags.Count);
  SetLength(FRights, FTags.Count);
  SetLength(FTops, FTags.Count);
  SetLength(FBottoms, FTags.Count);
  SetLength(FWidths, FTags.Count);
  SetLength(FCloseBtnLefts, FTags.Count);
  SetLength(FCloseBtnTops, FTags.Count);
  FCloseBtnWidth := Canvas.TextWidth('×'); // Canvas.Font must be right!
  FShrunk := false;

  FNumRows := 1;
  if FMultiLine then
  begin
    FActualTagHeight := FTagHeight;
    x := FSpacing;
    y := FSpacing;
    for i := 0 to FTags.Count - 1 do
    begin
      FWidths[i] := Canvas.TextWidth(FTags[i] + ' ×') + 2*FSpacing;
      FLefts[i] := x;
      FRights[i] := x + FWidths[i];
      FTops[i] := y;
      FBottoms[i] := y + FTagHeight;

      if x + FWidths[i] + FSpacing > ClientWidth then
   { no need to make room for the editor, since it can reside on the next row! }
      begin
        x := FSpacing;
        inc(y, FTagHeight + FSpacing);
        inc(FNumRows);
        FLefts[i] := x;
        FRights[i] := x + FWidths[i];
        FTops[i] := y;
        FBottoms[i] := y + FTagHeight;
      end;

      FCloseBtnLefts[i] := x + FWidths[i] - FCloseBtnWidth - FSpacing;
      FCloseBtnTops[i] := y;

      inc(x, FWidths[i] + FSpacing);
    end;
  end
  else // i.e., not FMultiLine
  begin
    FActualTagHeight := ClientHeight - 2*FSpacing;
    x := FSpacing;
    y := FSpacing;
    for i := 0 to FTags.Count - 1 do
    begin
      FWidths[i] := Canvas.TextWidth(FTags[i] + ' ×') + 2*FSpacing;
      FLefts[i] := x;
      FRights[i] := x + FWidths[i];
      FTops[i] := y;
      FBottoms[i] := y + FActualTagHeight;
      inc(x, FWidths[i] + FSpacing);
      FCloseBtnLefts[i] := FRights[i] - FCloseBtnWidth - FSpacing;
      FCloseBtnTops[i] := y;
    end;
    FShrunk := x + 64 {FEdit} > ClientWidth;
    if FShrunk then
    begin

      // Enough to remove close buttons?
      x := FSpacing;
      y := FSpacing;
      for i := 0 to FTags.Count - 1 do
      begin
        FWidths[i] := Canvas.TextWidth(FTags[i]) + 2*FSpacing;
        FLefts[i] := x;
        FRights[i] := x + FWidths[i];
        FTops[i] := y;
        FBottoms[i] := y + FActualTagHeight;
        inc(x, FWidths[i] + FSpacing);
        FCloseBtnLefts[i] := FRights[i] - FCloseBtnWidth - FSpacing;
        FCloseBtnTops[i] := y;
      end;

      if x + 64 {FEdit} > ClientWidth then // apparently not
      begin
        x := FSpacing;
        if FTags.Count > 0 then begin
          MeanWidth := (ClientWidth - 2*FSpacing - 64 {FEdit}) div FTags.Count - FSpacing;
          for i := 0 to FTags.Count - 1 do
          begin
            FWidths[i] := Min(FWidths[i], MeanWidth);
            FLefts[i] := x;
            FRights[i] := x  + FWidths[i];
            inc(x, FWidths[i] + FSpacing);
          end;
        end;
      end;
    end;
  end;

  FEditPos := Point(FSpacing, FSpacing + (FActualTagHeight - FEdit.Height) div 2);
  if FTags.Count > 0 then
    FEditPos := Point(FRights[FTags.Count - 1] + FSpacing,
      FTops[FTags.Count - 1] + (FActualTagHeight - FEdit.Height) div 2);
  if FMultiLine and (FEditPos.X + 64 > ClientWidth) and (FTags.Count > 0) then
  begin
    FEditPos := Point(FSpacing,
      FTops[FTags.Count - 1] + FTagHeight + FSpacing +
      (FActualTagHeight - FEdit.Height) div 2);
    inc(FNumRows);
  end;

  FDesiredHeight := FSpacing + FNumRows*(FTagHeight+FSpacing);
  AdjustedFDesiredHeight := Min(FDesiredHeight, FMaxHeight);
  if FMultiLine and FAutoHeight and (ClientHeight <> AdjustedFDesiredHeight) then
    ClientHeight := AdjustedFDesiredHeight;

  UpdateScrollBars;

end;

procedure TTagEditor.Paint;
var
  i: integer;
  w: integer;
  x, y: integer;
  R: TRect;
  S: string;
  clip: HRGN;
begin
  inherited;
  Canvas.Brush.Color := FBgColor;
  Canvas.Pen.Color := FBorderColor;
  Canvas.Rectangle(ClientRect);
  Canvas.Font.Assign(Self.Font);

  clip := CreateRectRgnIndirect(GetShrunkClientRect((3)));
  SelectClipRgn(Canvas.Handle, clip);
  DeleteObject(clip);

  for i := 0 to FTags.Count - 1 do
  begin
    x := FLefts[i];
    y := FTops[i] - FScrollInfo.nPos;
    w := FWidths[i];
    R := Rect(x, y, x + w, y + FActualTagHeight);
    Canvas.Brush.Color := FTagBgColor;
    Canvas.Pen.Color := FTagBorderColor;
    Canvas.Rectangle(R);
    Canvas.Font.Color := FTextColor;
    Canvas.Brush.Style := bsClear;
    R.Left := R.Left + FSpacing;
    S := FTags[i];
    if not FShrunk then
      S := S + ' ×';
    DrawText(Canvas.Handle, PChar(S), -1, R, DT_SINGLELINE or DT_VCENTER or
      DT_LEFT or DT_END_ELLIPSIS or DT_NOPREFIX);
    Canvas.Brush.Style := bsSolid;
  end;

  if FEdit.Visible then
  begin
    FEdit.Left := FEditPos.X;
    FEdit.Top := FEditPos.Y - FScrollInfo.nPos;
    FEdit.Width := ClientWidth - FEdit.Left - FSpacing;
  end;

  SelectClipRgn(Canvas.Handle, 0);

  if Focused then
    DrawFocusRect;
end;

function TTagEditor.GetShrunkClientRect(const Amount: integer): TRect;
begin
  result := Rect(Amount, Amount, ClientWidth - Amount, ClientHeight - Amount);
end;

procedure TTagEditor.DrawFocusRect;
var
  R: TRect;
begin
  R := GetShrunkClientRect(2);
  SafeDrawFocusRect(Canvas.Handle, R);
end;

procedure TTagEditor.SetAutoHeight(const Value: boolean);
begin
  if FAutoHeight <> Value then
  begin
    FAutoHeight := Value;
    UpdateMetrics;
    Invalidate;
  end;
end;

procedure TTagEditor.SetBgColor(const Value: TColor);
begin
  if FBgColor <> Value then
  begin
    FBgColor := Value;
    Invalidate;
  end;
end;

procedure TTagEditor.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TTagEditor.SetMaxHeight(const Value: integer);
begin
  if FMaxHeight <> Value then
  begin
    FMaxHeight := Value;
    UpdateMetrics;
    Invalidate;
  end;
end;

procedure TTagEditor.SetMultiLine(const Value: boolean);
begin
  if FMultiLine <> Value then
  begin
    FMultiLine := Value;
    UpdateMetrics;
    Invalidate;
  end;
end;

procedure TTagEditor.SetTagBgColor(const Value: TColor);
begin
  if FTagBgColor <> Value then
  begin
    FTagBgColor := Value;
    Invalidate;
  end;
end;

procedure TTagEditor.SetTagBorderColor(const Value: TColor);
begin
  if FTagBorderColor <> Value then
  begin
    FTagBorderColor := Value;
    Invalidate;
  end;
end;

procedure TTagEditor.SetTagHeight(const Value: integer);
begin
  if FTagHeight <> Value then
  begin
    FTagHeight := Value;
    UpdateMetrics;
    Invalidate;
  end;
end;

procedure TTagEditor.SetTags(const Value: TStringList);
begin
  FTags.Assign(Value);
  Invalidate;
end;

procedure TTagEditor.SetTextColor(const Value: TColor);
begin
  if FTextColor <> Value then
  begin
    FTextColor := Value;
    Invalidate;
  end;
end;

procedure TTagEditor.ShowEditor;
begin
  FEdit.Left := FEditPos.X;
  FEdit.Top := FEditPos.Y;
  FEdit.Width := ClientWidth - FEdit.Left - FSpacing;
  FEdit.Color := FEditorColor;
  FEdit.Text := '';
  FEdit.Show;
  FEdit.SetFocus;
end;

procedure TTagEditor.SetSpacing(const Value: integer);
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    UpdateMetrics;
    Invalidate;
  end;
end;

end.
