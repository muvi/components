unit AdvGui;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, GraphX32, Dialogs;

type
  TIndexBar           = class (TCustomControl)
  private
    FAutoSize         : Boolean;
    FMax              : Integer;
    FMin              : Integer;
    FSelected         : Integer;
    FImages           : TImageList;
    FDefaultImg       : Integer;
    FSelectedImg      : Integer;
    FVertical         : Boolean;
    FRectWidth        : Integer;
    FRectHeight       : Integer;
    FBorderSize       : Integer;
    FSelectedBmp      : TBitmap;
    FDefaultBmp       : TBitmap;
    FDefaultRectColor : TColor;
    FSelectedRectColor: TColor;
    procedure SetAutoSize(const Value: Boolean); reintroduce;
    procedure SetDefaultImg(const Value: Integer);
    procedure SetImages(const Value: TImageList);
    procedure SetSelected(const Value: Integer);
    procedure SetSelectedImg(const Value: Integer);
    procedure SetMin(const Value: Integer);
    procedure SetMax(const Value: Integer);
    procedure SetBorderSize(const Value: Integer);
    procedure SetSelectedRectColor(const Value: TColor);
    procedure SetDefaultRectColor(const Value: TColor);
    procedure SetRectWidth(const Value: Integer);
    procedure SetRectHeight(const Value: Integer);
    procedure SetVertical(const Value: Boolean);
  protected
    procedure Paint; override;
    procedure DoAutoSize;
    procedure RefreshStateBmps;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property BorderSize: Integer read FBorderSize write SetBorderSize;
    property Color;
    property DefaultImageIndex: Integer read FDefaultImg write SetDefaultImg;
    property DefaultRectColor: TColor read FDefaultRectColor write SetDefaultRectColor;
    property Height;
    property Images: TImageList read FImages write SetImages;
    property Selected: Integer read FSelected write SetSelected;
    property SelectedImageIndex: Integer read FSelectedImg write SetSelectedImg;
    property SelectedRectColor: TColor read FSelectedRectColor write SetSelectedRectColor;
    property Max: Integer read FMax write SetMax;
    property Min: Integer read FMin write SetMin;
    property RectHeight: Integer read FRectHeight write SetRectHeight;
    property RectWidth: Integer read FRectWidth write SetRectWidth;
    property TabStop;
    property Vertical: Boolean read FVertical write SetVertical;
    property Width;

    property OnClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TBufferedPaintBox   = class (TCustomControl)
  private
    FBuffer: TBitmap;
  protected
    procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure SetBuffer(Value: TBitmap);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearBuffer;
  published
    property Align;
    property Anchors;
    property BorderStyle;
    property BorderSpacing;
    property Buffer: TBitmap read FBuffer write SetBuffer;
    property Constraints;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Height;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property TabStop;
    property Visible;
    property Width;

    property OnChangeBounds;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
    property OnPaint;
    property OnQuadClick;
    property OnResize;
    property OnStartDrag;
    property OnTripleClick;
  end;

  TAlphaMorphBitmap   = class (TCustomControl)
  private
    FAlpha        : Byte;
    FAutoSize     : Boolean;
    FBuffer       : TBitmap;
    FMaxBmp       : TBitmap;
    FMinBmp       : TBitmap;
    FImages       : TImageList;
    FMaxImageIndex: Integer;
    FMinImageIndex: Integer;
    FUpdating     : Boolean;
    FPos          : TPoint;
    procedure SetAlpha(Value: Byte);
    procedure SetAutoSize(Value: Boolean);
    procedure SetImages(Value: TImageList);
    procedure SetMaxImageIndex(Value: Integer);
    procedure SetMinImageIndex(Value: Integer);

    procedure DoSetMaxImageIndex; inline;
    procedure DoSetMinImageIndex; inline;
    procedure DoAutoSize; inline;
  protected
    procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure DoAlphaMorph; inline;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate; inline;
    procedure EndUpdate; inline;
  published
    property Align;
    property Alpha: Byte read FAlpha write SetAlpha default 0;
    property Anchors;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property BorderStyle;
    property BorderSpacing;
    property Constraints;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Height;
    property Images: TImageList read FImages write SetImages;
    property MaxImageIndex: Integer read FMaxImageIndex write SetMaxImageIndex default -1;
    property MinImageIndex: Integer read FMinImageIndex write SetMinImageIndex default -1;
    property ParentColor;
    property ParentShowHint;
    property TabStop;
    property Visible;
    property Width;

    property OnChangeBounds;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
    property OnPaint;
    property OnQuadClick;
    property OnResize;
    property OnStartDrag;
    property OnTripleClick;
  end;

procedure Register;

implementation

{TIndexBar}

constructor TIndexBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMin:=1;
  FMax:=4;
  FSelected:=1;
  FAutoSize:=true;
  FDefaultImg:=-1;
  FSelectedImg:=-1;
  FVertical:=false;
  FRectWidth:=20;
  FRectHeight:=20;
  FBorderSize:=5;
  FDefaultRectColor:=clGray;
  FSelectedRectColor:=clRed;
  FSelectedBmp:=TBitmap.Create;
  FDefaultBmp:=TBitmap.Create;
  RefreshStateBmps;
end;

destructor TIndexBar.Destroy;
begin
  FDefaultBmp.Destroy;
  FSelectedBmp.Destroy;
  inherited Destroy;
end;

procedure TIndexBar.Paint;
var
  I          : Integer;
  X1,X2,Y1,Y2: Integer;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Brush.Color:=Color;
  Canvas.Rectangle(0,0,Width,Height);
  X1:=FBorderSize;
  Y1:=FBorderSize;
  X2:=X1+FRectWidth;
  Y2:=Y1+FRectHeight;
  if Vertical then for I:=Min to Max do begin
    if FSelected=I
      then Canvas.Draw(X1,Y1,FSelectedBmp)
      else Canvas.Draw(X1,Y1,FDefaultBmp);
    Y1:=Y2+FBorderSize;
    Y2:=Y1+FRectWidth;
  end else for I:=Min to Max do begin
    if FSelected=I
      then Canvas.Draw(X1,Y1,FSelectedBmp)
      else Canvas.Draw(X1,Y1,FDefaultBmp);
    X1:=X2+FBorderSize;
    X2:=X1+FRectWidth;
  end;
end;

procedure TIndexBar.DoAutoSize;
begin
  if not FAutoSize then begin
    Paint;
    exit;
  end;
  if Vertical then begin
    Width:=FRectWidth+(FBorderSize*2);
    Height:=((FMax-FMin+1)*(FRectHeight+FBorderSize))+FBorderSize;
  end else begin
    Width:=((FMax-FMin+1)*(FRectWidth+FBorderSize))+FBorderSize;
    Height:=FRectHeight+(FBorderSize*2);
  end;
end;

procedure TIndexBar.RefreshStateBmps;

  procedure _FillImage(var ABmp: TBitmap; const AColor: TColor);
  begin
    with ABmp do begin
      Width:=FRectWidth;
      Height:=FRectHeight;
      Canvas.Pen.Color:=AColor;
      Canvas.Brush.Color:=AColor;
      Canvas.Rectangle(0,0,Width,Height);
    end;
  end;

  procedure _SetImage(var ABmp: TBitmap; const AIndex: Integer);
  begin
    FImages.GetBitmap(AIndex,ABmp);
  end;

begin
  if FImages<>nil then begin
    FRectWidth:=FImages.Width;
    FRectHeight:=FImages.Height;
  end;
  _FillImage(FDefaultBmp,FDefaultRectColor);
  _FillImage(FSelectedBmp,FSelectedRectColor);
  if FImages<>nil then begin
    if FDefaultImg>=0 then _SetImage(FDefaultBmp,FDefaultImg);
    if FSelectedImg>=0 then _SetImage(FSelectedBmp,FSelectedImg);
  end;
end;

procedure TIndexBar.SetAutoSize(const Value: Boolean);
begin
  FAutoSize:=Value;
  if Value then DoAutoSize;
end;

procedure TIndexBar.SetDefaultImg(const Value: Integer);
begin
  if FImages<>nil then begin
    if (Value>=0) and (Value<FImages.Count)
      then FDefaultImg:=Value
      else FDefaultImg:=-1;
  end else begin
    if Value>=0
      then FDefaultImg:=Value
      else FDefaultImg:=-1;
  end;
  RefreshStateBmps;
  Paint;
end;

procedure TIndexBar.SetImages(const Value: TImageList);
begin
  FImages:=Value;
  if Value=nil then begin
    FDefaultImg:=-1;
    FSelectedImg:=-1;
  end else begin
    if FDefaultImg>=FImages.Count then FDefaultImg:=-1;
    if FSelectedImg>=FImages.Count then FSelectedImg:=-1;
  end;
  RefreshStateBmps;
  DoAutoSize;
end;

procedure TIndexBar.SetSelected(const Value: Integer);
begin
  if FSelected=Value then exit;
  FSelected:=Value;
  Paint;
end;

procedure TIndexBar.SetSelectedImg(const Value: Integer);
begin
  if FImages<>nil then begin
    if (Value>=0) and (Value<FImages.Count)
      then FSelectedImg:=Value
      else FSelectedImg:=-1;
  end else begin
    if Value>=0
      then FSelectedImg:=Value
      else FSelectedImg:=-1;
  end;
  RefreshStateBmps;
  Paint;
end;

procedure TIndexBar.SetMin(const Value: Integer);
begin
  if Value<=FMax
    then FMin:=Value
    else FMin:=FMax;
  DoAutoSize;
end;

procedure TIndexBar.SetMax(const Value: Integer);
begin
  if Value>=FMin
    then FMax:=Value
    else FMax:=FMin;
  DoAutoSize;
end;

procedure TIndexBar.SetBorderSize(const Value: Integer);
begin
  FBorderSize:=Value;
  DoAutoSize;
end;

procedure TIndexBar.SetSelectedRectColor(const Value: TColor);
begin
  FSelectedRectColor:=Value;
  RefreshStateBmps;
  Paint;
end;

procedure TIndexBar.SetDefaultRectColor(const Value: TColor);
begin
  FDefaultRectColor:=Value;
  RefreshStateBmps;
  Paint;
end;

procedure TIndexBar.SetRectWidth(const Value: Integer);
begin
  if FImages<>nil then exit;
  FRectWidth:=Value;
  RefreshStateBmps;
  DoAutoSize;
end;

procedure TIndexBar.SetRectHeight(const Value: Integer);
begin
  if FImages<>nil then exit;
  FRectHeight:=Value;
  RefreshStateBmps;
  DoAutoSize;
end;

procedure TIndexBar.SetVertical(const Value: Boolean);
begin
  FVertical:=Value;
  DoAutoSize;
end;

{TBufferedPaintBox}

constructor TBufferedPaintBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBuffer:=TBitmap.Create;
end;

destructor TBufferedPaintBox.Destroy;
begin
  FBuffer.Destroy;
  inherited Destroy;
end;

procedure TBufferedPaintBox.ClearBuffer;
begin
  with FBuffer do begin
    Canvas.Brush.Color:=Color;
    Canvas.Pen.Color:=Color;
    Canvas.Font:=Font;
    Canvas.Rectangle(0,0,Width,Height);
  end;
end;

procedure TBufferedPaintBox.MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  if TabStop then SetFocus;
end;

procedure TBufferedPaintBox.Paint;
begin
  inherited Paint;
  Canvas.Draw(0,0,FBuffer);
end;

procedure TBufferedPaintBox.Resize;
begin
  inherited Resize;
  FBuffer.Canvas.Brush.Color:=Color;
  FBuffer.SetSize(Width,Height);
end;

procedure TBufferedPaintBox.SetBuffer(Value: TBitmap);
begin
  ClearBuffer;
  FBuffer.Canvas.Draw(0,0,Value);
  Paint;
end;

{TAlphaMorphBitmap}

constructor TAlphaMorphBitmap.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBuffer:=TBitmap.Create;
  FMaxBmp:=TBitmap.Create;
  FMinBmp:=TBitmap.Create;
  FImages:=nil;
  FMaxImageIndex:=-1;
  FMinImageIndex:=-1;
  FAlpha:=0;
  FAutoSize:=true;
  FUpdating:=true;
  FPos:=Point(0,0);
end;

destructor TAlphaMorphBitmap.Destroy;
begin
  FBuffer.Destroy;
  FMaxBmp.Destroy;
  FMinBmp.Destroy;
  inherited Destroy;
end;

procedure TAlphaMorphBitmap.BeginUpdate;
begin
  FUpdating:=true;
end;

procedure TAlphaMorphBitmap.EndUpdate;
begin
  if not FUpdating then exit;
  FUpdating:=false;

  if FImages<>nil then begin
    FBuffer.SetSize(FImages.Width,FImages.Height);
    FMaxBmp.SetSize(FImages.Width,FImages.Height);
    FMinBmp.SetSize(FImages.Width,FImages.Height);
  end else begin
    FBuffer.SetSize(0,0);
    FMaxBmp.SetSize(0,0);
    FMinBmp.SetSize(0,0);
    FMaxImageIndex:=-1;
    FMinImageIndex:=-1;
  end;
  DoSetMaxImageIndex;
  DoSetMinImageIndex;
  FBuffer.Transparent:=(FMaxBmp.Transparent and FMinBmp.Transparent);
  DoAlphaMorph;
  DoAutoSize;
end;

procedure TAlphaMorphBitmap.MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  if TabStop then SetFocus;
end;

procedure TAlphaMorphBitmap.Paint;
begin
  EndUpdate;
  inherited Paint;
  Canvas.Draw(FPos.X,FPos.Y,FBuffer)
end;

procedure TAlphaMorphBitmap.Resize;
begin
  EndUpdate;
  inherited Resize;
  DoAutoSize;
end;

procedure TAlphaMorphBitmap.DoAlphaMorph;
var
  I,J              : Integer;
begin
  FBuffer.BeginUpdate(true);
  if FBuffer.Transparent then FBuffer.TransparentColor:=BlendAlpha(FAlpha,FMinBmp.TransparentColor,FMaxBmp.TransparentColor);
  for I:=0 to FBuffer.Height-1
    do for J:=0 to FBuffer.Width-1
      do FBuffer.Canvas.Pixels[J,I]:=BlendAlpha(FAlpha,FMinBmp.Canvas.Pixels[J,I],FMaxBmp.Canvas.Pixels[J,I]);
  FBuffer.EndUpdate;
end;

procedure TAlphaMorphBitmap.SetAlpha(Value: Byte);
begin
  FAlpha:=Value;
  if FUpdating then exit;
  DoAlphaMorph;
  Paint;
end;

procedure TAlphaMorphBitmap.SetImages(Value: TImageList);
begin
  FImages:=Value;
  if FUpdating then exit;
  if FImages<>nil then begin
    FBuffer.SetSize(FImages.Width,FImages.Height);
    FMaxBmp.SetSize(FImages.Width,FImages.Height);
    FMinBmp.SetSize(FImages.Width,FImages.Height);
  end else begin
    FBuffer.SetSize(0,0);
    FMaxBmp.SetSize(0,0);
    FMinBmp.SetSize(0,0);
    FMaxImageIndex:=-1;
    FMinImageIndex:=-1;
  end;
  DoSetMaxImageIndex;
  DoSetMinImageIndex;
  FBuffer.Transparent:=(FMaxBmp.Transparent and FMinBmp.Transparent);
  DoAlphaMorph;
  DoAutoSize;
  Paint;
end;

procedure TAlphaMorphBitmap.SetMaxImageIndex(Value: Integer);
begin
  if (not FUpdating) and ((Value=FMaxImageIndex) or (FImages=nil)) then exit;
  FMaxImageIndex:=Value;
  if FUpdating then exit;
  DoSetMaxImageIndex;
  FBuffer.Transparent:=(FMaxBmp.Transparent and FMinBmp.Transparent);
  DoAlphaMorph;
  Paint;
end;

procedure TAlphaMorphBitmap.SetMinImageIndex(Value: Integer);
begin
  if (not FUpdating) and ((Value=FMinImageIndex) or (FImages=nil)) then exit;
  FMinImageIndex:=Value;
  if FUpdating then exit;
  DoSetMinImageIndex;
  FBuffer.Transparent:=(FMaxBmp.Transparent and FMinBmp.Transparent);
  DoAlphaMorph;
  Paint;
end;

procedure TAlphaMorphBitmap.DoSetMaxImageIndex;
begin
  if FMaxImageIndex>=0 then begin
    FImages.GetBitmap(FMaxImageIndex,FMaxBmp);
  end else with FMaxBmp do begin
    Canvas.Pen.Color:=clWhite;
    Canvas.Brush.Color:=clWhite;
    Canvas.Rectangle(0,0,Width,Height);
    Transparent:=false;
  end;
end;

procedure TAlphaMorphBitmap.DoSetMinImageIndex;
begin
  if FMinImageIndex>=0 then begin
    FImages.GetBitmap(FMinImageIndex,FMinBmp);
  end else with FMinBmp do begin
    Canvas.Pen.Color:=clBlack;
    Canvas.Brush.Color:=clBlack;
    Canvas.Rectangle(0,0,Width,Height);
    Transparent:=false;
  end;
end;

procedure TAlphaMorphBitmap.DoAutoSize;
begin
  if FAutoSize then begin
    Width:=FBuffer.Width;
    Height:=FBuffer.Height;
    FPos:=Point(0,0);
  end else FPos:=Point((Width-FBuffer.Width) div 2,(Height-FBuffer.Height) div 2);
end;

procedure TAlphaMorphBitmap.SetAutoSize(Value: Boolean);
begin
  FAutoSize:=Value;
  DoAutoSize;
end;

{Allgemein}

procedure Register;
begin
  RegisterComponents('Erweitert',[TIndexBar,TBufferedPaintBox,TAlphaMorphBitmap]);
end;

end.

