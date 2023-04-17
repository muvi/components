unit StyleControls;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Controls, SplitImageButtons, GraphX32,
  CanvasGraphX32;

type
  TRectStyle         = (rsDefault, rsRound, rsCut);

  TStyleControlStyle = class (TComponent)
  strict private
    FTitlePicLeft  : TBitmap;
    FTitlePicMiddle: TBitmap;
    FTitlePicRight : TBitmap;
    FTempPic       : TBitmap;
    FImages        : TImageList;
    FTitlePicIndex : Integer;
    FBorderColor   : TColor;
    FRectStyle     : TRectStyle;
    FTitleLayout   : TTextLayout;
    FTitleAlignment: TAlignment;
    FCornerSize    : Integer;
    procedure SetImages(Value: TImageList);
    procedure SetTitlePic(Value: TBitmap);
    function GetTitlePic: TBitmap;
    function GetTitlePicHeight: Integer;
    procedure SetTitlePicIndex(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DrawTitlePic(ACanvas: TCanvas; AViewRect: TRect; X,Y,AWidth: Integer); overload;
    procedure DrawTitlePic(ACanvas: TCanvas; X,Y,AWidth: Integer); overload;
    procedure DrawStyleRect(ACanvas: TCanvas; X1, Y1, X2, Y2, RX, RY: Integer);

    property TitlePic      : TBitmap read GetTitlePic write SetTitlePic;
    property TitlePicLeft  : TBitmap read FTitlePicLeft;
    property TitlePicMiddle: TBitmap read FTitlePicMiddle;
    property TitlePicRight : TBitmap read FTitlePicRight;
  published
    property BorderColor: TColor read FBorderColor write FBorderColor default clWindowFrame;
    property CornerSize: Integer read FCornerSize write FCornerSize default 25;
    property Images: TImageList read FImages write SetImages;
    property RectStyle: TRectStyle read FRectStyle write FRectStyle default rsDefault;
    property TitleAlignment: TAlignment read FTitleAlignment write FTitleAlignment default taCenter;
    property TitlePicHeight: Integer read GetTitlePicHeight;
    property TitlePicIndex: Integer read FTitlePicIndex write SetTitlePicIndex;
    property TitleLayout: TTextLayout read FTitleLayout write FTitleLayout default tlCenter;
  end;

  TStyleBox          = class (TCustomControl)
  private
    FStyle: TStyleControlStyle;
    procedure SetStyle(Value: TStyleControlStyle);
  protected
    procedure Paint; override;
    procedure TextChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property BorderSpacing;
    property BiDiMode;
    property Caption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Constraints;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Height;
    property ParentColor;
    property ParentShowHint;
    property Style: TStyleControlStyle read FStyle write SetStyle;
    property TabOrder;
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

{%REGION TStyleControlStyle}

constructor TStyleControlStyle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTempPic:=TBitmap.Create;
  FTitlePicLeft:=TBitmap.Create;
  FTitlePicMiddle:=TBitmap.Create;
  FTitlePicRight:=TBitmap.Create;
  //init
  FRectStyle:=rsDefault;
  FCornerSize:=25;
  FBorderColor:=clWindowFrame;
  FTitleLayout:=tlCenter;
  FTitleAlignment:=taCenter;
end;

destructor TStyleControlStyle.Destroy;
begin
  FTitlePicRight.Destroy;
  FTitlePicMiddle.Destroy;
  FTitlePicLeft.Destroy;
  FTempPic.Destroy;
  inherited Destroy;
end;

procedure TStyleControlStyle.DrawTitlePic(ACanvas: TCanvas; AViewRect: TRect; X,Y,AWidth: Integer);
begin
  DrawSIButtonH(ACanvas,AViewRect,FTitlePicLeft,FTitlePicMiddle,FTitlePicRight,X,Y,AWidth);
end;

procedure TStyleControlStyle.DrawTitlePic(ACanvas: TCanvas; X,Y,AWidth: Integer);
begin
  DrawSIButtonH(ACanvas,Rect(0,0,ACanvas.ClipRect.Right,ACanvas.ClipRect.Bottom),FTitlePicLeft,FTitlePicMiddle,FTitlePicRight,X,Y,AWidth);
end;

procedure TStyleControlStyle.SetTitlePic(Value: TBitmap);
begin
  SplitImageH(Value,FTitlePicLeft,FTitlePicMiddle,FTitlePicRight);
end;

procedure TStyleControlStyle.DrawStyleRect(ACanvas: TCanvas; X1, Y1, X2, Y2, RX, RY: Integer);
begin
  case FRectStyle of
    rsDefault: DrawRect(ACanvas, X1,Y1,X2,Y2);
    rsRound  : ACanvas.RoundRect(X1,Y1,X2,Y2,RX,RY);
    rsCut    : DrawCutRect(ACanvas, X1, Y1, X2, Y2, RX, RY);
  end;
end;

procedure TStyleControlStyle.SetImages(Value: TImageList);
begin
  FImages:=Value;
  if FTitlePicIndex>=0 then begin
    FImages.GetBitmap(FTitlePicIndex,FTempPic);
    SetTitlePic(FTempPic);
  end;
end;

function TStyleControlStyle.GetTitlePic: TBitmap;
begin
  with FTempPic do begin
    Width:=FTitlePicLeft.Width+FTitlePicMiddle.Width+FTitlePicRight.Width;
    Height:=FTitlePicMiddle.Height;
    with Canvas do begin
      Draw(0,0,FTitlePicLeft);
      Draw(FTitlePicLeft.Width,0,FTitlePicMiddle);
      Draw(FTitlePicLeft.Width+FTitlePicMiddle.Width,0,FTitlePicRight);
    end;
  end;
  Result:=FTempPic;
end;

function TStyleControlStyle.GetTitlePicHeight: Integer;
begin
  Result:=FTitlePicMiddle.Height;
end;

procedure TStyleControlStyle.SetTitlePicIndex(Value: Integer);
begin
  if Value>=0 then begin
    FTitlePicIndex:=Value;
    if FImages<>nil then begin
      FImages.GetBitmap(Value,FTempPic);
      SetTitlePic(FTempPic);
    end;
  end else FTitlePicIndex:=-1;
end;

{%ENDREGION}
{%REGION TStyleBox}

constructor TStyleBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csAcceptsControls];
  SetInitialBounds(0,0,185,105);
  ChildSizing.HorizontalSpacing:=10;
end;

destructor TStyleBox.Destroy;
begin
  inherited Destroy;
end;

procedure TStyleBox.Paint;
var
  AHeaderLeft,AHeaderTextWidth: Integer;
begin
  if FStyle=nil then exit;
  Canvas.Pen.Color:=FStyle.BorderColor;
  Canvas.Pen.JoinStyle:=pjsMiter;
  Canvas.Brush.Color:=Color;
  Canvas.Pen.Width:=4;
  case FStyle.TitleLayout of
    tlTop   : FStyle.DrawStyleRect(Canvas, 2,FStyle.TitlePicHeight-2,Width-2,Height-2,FStyle.CornerSize,FStyle.CornerSize);
    tlCenter: FStyle.DrawStyleRect(Canvas, 2,FStyle.TitlePicHeight div 2,Width-2,Height-2,FStyle.CornerSize,FStyle.CornerSize);
    tlBottom: FStyle.DrawStyleRect(Canvas, 2,2,Width-2,Height-2,FStyle.CornerSize,FStyle.CornerSize);
  end;
  Canvas.Brush.Style:=bsClear;
  AHeaderTextWidth:=Canvas.TextWidth(Caption);
  case FStyle.TitleAlignment of
    taLeftJustify : AHeaderLeft:=10;
    taCenter      : AHeaderLeft:=((Width-AHeaderTextWidth) div 2)-FStyle.TitlePicLeft.Width;
    taRightJustify: AHeaderLeft:=Width-AHeaderTextWidth-FStyle.TitlePicLeft.Width-20;
  end;
  with FStyle do DrawTitlePic(Canvas,AHeaderLeft,0,AHeaderTextWidth+TitlePicLeft.Width+TitlePicRight.Width);
  Canvas.TextOut(AHeaderLeft+FStyle.TitlePicLeft.Width,(FStyle.TitlePicHeight-Canvas.TextHeight('Wg')) div 2,Caption);
  Canvas.Brush.Style:=bsSolid;
end;

procedure TStyleBox.TextChanged;
begin
  Paint;
end;

procedure TStyleBox.SetStyle(Value: TStyleControlStyle);
begin
  FStyle:=Value;
  Paint;
end;

{%ENDREGION}
{%REGION Misc}

procedure Register;
begin
  RegisterComponents('Erweitert',[TStyleCOntrolStyle,TStyleBox]);
end;

{%ENDREGION}

end.

