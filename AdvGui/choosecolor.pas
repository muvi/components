unit ChooseColor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Math, GraphX32, Controls, AdvCoord, AdvFunc,
  CanvasGraphX32;

type
  THSVColorChooser = class (TCustomControl)
  private
    FSize        : Real;
    FWH          : Integer;
    FWH2         : Integer;
    FHueBuffer   : TBitmap;
    FSVBuffer    : TBitmap;
    FPaintBuffer : TBitmap;
    FSelColor32  : TColor32;
    FSelHSV      : TAHSV;
    FHueWidth    : Integer;
    FTriXStart   : Integer;
    FTriPosX     : Integer;
    FMDOnHue     : Boolean;
    FMDOnSV      : Boolean;
    FOnChange    : TNotifyEvent;
    procedure SetSize(Value: Real);
    function GetSelColor: TColor;
    procedure SetSelColor(Value: TColor);
    procedure SetSelColor32(Value: TColor32);
    procedure SetSelHSV(const Value: TAHSV);
    procedure SetHueWidth(Value: Integer);
    function GetBGColor: TColor;
    procedure SetBGColor(Value: TColor);

    procedure UpdateSize;
    procedure UpdateHue;
    procedure UpdateSV;
    procedure UpdateSelection;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SelColor32: TColor32 read FSelColor32 write SetSelColor32;
    property SelHSV: TAHSV read FSelHSV write SetSelHSV;
  published
    property Anchors;
    property AutoSize default true;
    property BGColor: TColor read GetBGColor write SetBGColor default clBtnFace;
    property Enabled;
    property Height;
    property HueWidth: Integer read FHueWidth write SetHueWidth default 20;
    property SelColor: TColor read GetSelColor write SetSelColor;
    property ShowHint;
    property Size: Real read FSize write SetSize;
    property TabStop;
    property Visible;
    property Width;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
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

  TAlphaBar        = class (TCustomControl)
  private
    FSelColor32 : TColor32;
    FAlphaBuffer: TBitmap;
    FSquareSize : Integer;
    FSqrColor1  : TColor;
    FSqrColor2  : TColor;
    FOnChange   : TNotifyEvent;
    FMouseIsDown: Boolean;
    function GetSelColor: TColor;
    procedure SetSelColor(Value: TColor);
    procedure SetSelColor32(Value: TColor32);
    function GetSelAlpha: Byte;
    procedure SetSelAlpha(Value: Byte);
    procedure SetSquareSize(Value: Integer);
    procedure SetSqrColor1(Value: TColor);
    procedure SetSqrColor2(Value: TColor);

    procedure UpdateColor;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SelColor32: TColor32 read FSelColor32 write SetSelColor32;
  published
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property Enabled;
    property Height;
    property SelAlpha: Byte read GetSelAlpha write SetSelAlpha;
    property SelColor: TColor read GetSelColor write SetSelColor;
    property ShowHint;
    property SquareSize: Integer read FSquareSize write SetSquareSize default 6;
    property SqrColor1: TColor read FSqrColor1 write SetSqrColor1 default clWhite;
    property SqrColor2: TColor read FSqrColor2 write SetSqrColor2 default clBlack;
    property TabStop;
    property Visible;
    property Width;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
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

  TGridColorChooser   = class (TCustomControl)
  private
    FBuffer        : TBitmap;
    FColors        : array of TColor32;
    FColorWidth    : Integer;
    FColorHeight   : Integer;
    FAlphaWidth    : Integer;
    FAlphaHeight   : Integer;
    FColorsPerRow  : Integer;
    FColorIndex    : Integer;
    FMouseOverIndex: Integer;
    FColorDist     : Integer;
    FAlphaColor1   : TColor;
    FAlphaColor2   : TColor;
    FSelColor32    : TColor32;
    FOnChange      : TNotifyEvent;
    FOnChanged     : TNotifyEvent;
    FUpdating      : Boolean;
    FChanged       : Boolean;
    function GetColorItem(Index: Integer): TColor;
    procedure SetColorItem(Index: Integer; Value: TColor);
    function GetColor32Item(Index: Integer): TColor32;
    procedure SetColor32Item(Index: Integer; Value: TColor32);
    function GetAlphaItem(Index: Integer): Byte;
    procedure SetAlphaItem(Index: Integer; Value: Byte);
    function GetCount: Integer;
    procedure SetCount(Value: Integer);
    procedure SetColorWidth(Value: Integer);
    procedure SetColorHeight(Value: Integer);
    procedure SetAlphaWidth(Value: Integer);
    procedure SetAlphaHeight(Value: Integer);
    procedure SetColorDist(Value: Integer);
    procedure SetAlphaColor1(Value: TColor);
    procedure SetAlphaColor2(Value: TColor);
    function GetBGColor: TColor;
    procedure SetBGColor(Value: TColor);
    procedure SetColorIndex(Value: Integer);
    procedure SetSelColor32(Value: TColor32);
    function GetSelColor: TColor;
    procedure SetSelColor(Value: TColor);
    function GetSelAlpha: Byte;
    procedure SetSelAlpha(Value: Byte);

    procedure SelectionRect(Index: Integer; ACanvas: TCanvas; var ARect: TRect; AC1,AC2: TColor);
    procedure CheckColorIndex(Index: Integer);
    procedure UpdateColorIndex;
    procedure UpdateColor(Index: Cardinal);
    procedure UpdateColors;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure MouseLeave; override;
    property Buffer: TBitmap read FBuffer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartUpdate;
    procedure EndUpdate;

    property Alphas[Index: Integer]: Byte read GetAlphaItem write SetAlphaItem;
    property Colors[Index: Integer]: TColor read GetColorItem write SetColorItem;
    property Colors32[Index: Integer]: TColor32 read GetColor32Item write SetColor32Item;
    property ColorsPerRow: Integer read FColorsPerRow;
    property SelColor32: TColor32 read FSelColor32 write SetSelColor32;
  published
    property Align;
    property AlphaColor1: TColor read FAlphaColor1 write SetAlphaColor1 default clWhite;
    property AlphaColor2: TColor read FAlphaColor2 write SetAlphaColor2 default clBlack;
    property AlphaHeight: Integer read FAlphaHeight write SetAlphaHeight default 6;
    property AlphaWidth: Integer read FAlphaWidth write SetAlphaWidth default 6;
    property Anchors;
    property BGColor: TColor read GetBGColor write SetBGColor default clBtnFace;
    property BorderStyle;
    property BorderSpacing;
    property ColorIndex: Integer read FColorIndex write SetColorIndex default -1;
    property ColorDist: Integer read FColorDist write SetColorDist default 3;
    property ColorHeight: Integer read FColorHeight write SetColorHeight default 15;
    property ColorWidth: Integer read FColorWidth write SetColorWidth default 20;
    property Constraints;
    property Count: Integer read GetCount write SetCount;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Height;
    property ParentColor;
    property ParentShowHint;
    property SelAlpha: Byte read GetSelAlpha write SetSelAlpha;
    property SelColor: TColor read GetSelColor write SetSelColor;
    property TabStop;
    property Visible;
    property Width;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChangeBounds;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
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

{THSVColorChooser}

const
  HSVCCSize  = 320;
  HuePieR    = 400;

constructor THSVColorChooser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHueBuffer:=TBitmap.Create;
  FSVBuffer:=TBitmap.Create;
  FSVBuffer.Transparent:=true;
  FPaintBuffer:=TBitmap.Create;
  Color:=clBtnFace;

  FMDOnHue:=false;
  FMDOnSV:=false;
  FHueWidth:=20;
  AutoSize:=true;
  FSelColor32:=$FFFF0000;
  FSelHSV:=ARGBToAHSV(FSelColor32);
  SetSize(0.5);
end;

destructor THSVColorChooser.Destroy;
begin
  FPaintBuffer.Destroy;
  FSVBuffer.Destroy;
  FHueBuffer.Destroy;
  inherited Destroy;
end;

procedure THSVColorChooser.Paint;
begin
  Canvas.Draw(0,0,FPaintBuffer);
end;

procedure THSVColorChooser.Resize;
begin
  if AutoSize then begin
    Width:=FWH;
    Height:=FWH;
  end;
end;

procedure THSVColorChooser.MouseMove(Shift: TShiftState; X,Y: Integer);
var
  AY,AY2,AX: Integer;
begin
  if not Enabled then exit;
  inherited MouseMove(Shift,X,Y);
  if FMDOnHue then begin
    FSelHSV.H:=Arctan2(Y-FWH2,X-FWH2);
    if FSelHSV.H<0.0 then FSelHSV.H:=2*pi+FSelHSV.H;
    FSelColor32:=AHSVToARGB(FSelHSV);
    UpdateSV;
    Paint;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
  if FMDOnSV then begin
    AY:=Y-FHueWidth;
    if AY<0 then begin
      FSelHSV.V:=0;
      AY:=0;
    end else begin
      AY2:=Round($FF*FSize);
      if AY>AY2 then begin
        FSelHSV.V:=$FF;
        AY:=AY2;
      end else FSelHSV.V:=Round(AY/FSize);
    end;
    AX:=X-FWH2+(AY div 2);
    if (AX<0) then FSelHSV.S:=0 else begin
      if (AX>AY)
        then FSelHSV.S:=$FF
        else FSelHSV.S:=Round(($FF/(AY+1))*AX);
    end;
    FSelColor32:=AHSVToARGB(FSelHSV);
    UpdateSelection;
    Paint;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure THSVColorChooser.MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
var
  ADist : Real;
  AY,AY2: Integer;
begin
  inherited MouseDown(Button,Shift,X,Y);
  if TabStop then SetFocus;
  ADist:=sqrt(sqr(X-FWH2)+sqr(Y-FWH2));
  FMDOnHue:=((ADist<=FWH2) and (ADist>=FWH2-FHueWidth));
  if not FMDOnHue then begin
    AY:=Y-FHueWidth;
    AY2:=AY div 2;
    FMDOnSV:=((AY>=0) and (AY<=$FF*FSize) and (X>=FWH2-AY2) and (X<=FWH2-AY2+AY));
  end;

  MouseMove(Shift,X,Y);
end;

procedure THSVColorChooser.MouseUp(Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
begin
  inherited MouseUp(Button,Shift,X,Y);
  MouseMove(Shift,X,Y);
  FMDOnHue:=false;
  FMDOnSV:=false;
end;

procedure THSVColorChooser.UpdateSize;
begin
  FWH:=Round(HSVCCSize*FSize)+(FHueWidth*2);
  FWH2:=Round((HSVCCSize*FSize)/2)+FHueWidth;
  if AutoSize then begin
    Width:=FWH;
    Height:=FWH;
  end;
  UpdateHue;
  if not AutoSize then Paint;
end;

procedure THSVColorChooser.UpdateHue;
const
  HStep = pi/180;
  HCount= 360;
var
  I        : Integer;
  AHSV     : TAHSV;
  ALH      : Real;
  ATriSize : Integer;
begin
  FHueBuffer.SetSize(FWH,FWH);
  FPaintBuffer.SetSize(FWH,FWH);
  with FHueBuffer do begin
    Canvas.Pen.Color:=Color;
    Canvas.Brush.Color:=Color;
    Canvas.Rectangle(0,0,Width,Height);

    with AHSV do begin
      A:=$FF;
      S:=$FF;
      V:=$FF;
      H:=0.0;
    end;

    for I:=0 to HCount-1 do begin
      ALH:=AHSV.H;
      AHSV.H+=HStep;
      Canvas.Brush.Color:=Color32ToColor(AHSVToARGB(AHSV));
      Canvas.Pen.Color:=Canvas.Brush.Color;
      Canvas.Pie(0,0,FWH,FWH,Round(FWH2+HuePieR*Cos(AHSV.H)),Round(FWH2+HuePieR*Sin(AHSV.H)),Round(FWH2+HuePieR*Cos(ALH)),Round(FWH2+HuePieR*Sin(ALH)));
    end;
    Canvas.Pen.Color:=Color;
    Canvas.Brush.Color:=Color;
    Canvas.Ellipse(FHueWidth,FHueWidth,FWH-FHueWidth,FWH-FHueWidth);
  end;

  ATriSize:=Round($100*FSize);
  FSVBuffer.SetSize(ATriSize,ATriSize);
  FTriXStart:=ATriSize div 2;
  FTriPosX:=(FWH-ATriSize) div 2;

  UpdateSV;
end;

procedure THSVColorChooser.UpdateSV;
var
  I,J        : Integer;
  AHSV       : TAHSV;
  SStep,VStep: Real;
  TriPos     : TPoint;
begin
  with FSVBuffer do begin
    with AHSV do begin
      A:=$FF;
      H:=PhiCut(FSelHSV.H+pi);
      S:=$FF;
      V:=$FF;
    end;
    Canvas.Pen.Color:=Color32ToColor(AHSVToARGB(AHSV));
    Canvas.Brush.Color:=Canvas.Pen.Color;
    Canvas.Rectangle(0,0,Width,Height);
    TransparentColor:=Canvas.Brush.Color;
    Transparent:=true;
    with AHSV do begin
      H:=FSelHSV.H;
      V:=0;
    end;

    with AHSV do begin
      TriPos.Y:=0;
      VStep:=(1/FSize);
      for I:=0 to Height-1 do begin
        V:=Round(I*VStep);
        SStep:=($FF/(I+1));
        TriPos.X:=FTriXStart-(I div 2);
        for J:=0 to I do begin
          S:=Round(J*SStep);
          Canvas.Pixels[TriPos.X,TriPos.Y]:=Color32ToColor(AHSVToARGB(AHSV));
          Inc(TriPos.X);
        end;
        Inc(TriPos.Y);
      end;
    end;
  end;
  UpdateSelection;
end;

procedure THSVColorChooser.UpdateSelection;
var
  ASin  : TRealPoint;
  TriPos: TPoint;
  VPos  : Integer;
begin
  with FPaintBuffer do begin
    Canvas.Draw(0,0,FHueBuffer);
    Canvas.Draw(FTriPosX,FHueWidth,FSVBuffer);
    Canvas.Pen.Width:=3;
    ASin:=RealPoint(Cos(FSelHSV.H),Sin(FSelHSV.H));
    Canvas.Pen.Color:=clBlack;
    Canvas.MoveTo(Round(FWH2+FWH2*ASin.X),Round(FWH2+FWH2*ASin.Y));
    Canvas.LineTo(Round(FWH2+(FWH2-FHueWidth)*ASin.X),Round(FWH2+(FWH2-FHueWidth)*ASin.Y));

    Canvas.Pen.Width:=2;
    VPos:=Round(FSelHSV.V*FSize);
    TriPos.Y:=FHueWidth+VPos;
    TriPos.X:=Round(FWH2-(VPos/2)+(VPos/$FF)*FSelHSV.S);
    if FSelHSV.V>=$7F
      then Canvas.Pen.Color:=clBlack
      else Canvas.Pen.Color:=clWhite;
    Canvas.Brush.Style:=bsClear;
    Canvas.Ellipse(TriPos.X-4,TriPos.Y-4,TriPos.X+4,TriPos.Y+4);
    Canvas.Brush.Style:=bsSolid;
  end;
end;

procedure THSVColorChooser.SetSize(Value: Real);
begin
  FSize:=Value;
  UpdateSize;
end;

function THSVColorChooser.GetSelColor: TColor;
begin
  Result:=Color32ToColor(FSelColor32);
end;

procedure THSVColorChooser.SetSelColor(Value: TColor);
begin
  FSelColor32:=ColorToColor32(Value);
  FSelHSV:=ARGBToAHSV(FSelColor32);
  UpdateSV;
  Paint;
end;

procedure THSVColorChooser.SetSelColor32(Value: TColor32);
begin
  if (FSelColor32 and $00FFFFFF) = (Value and $00FFFFFF) then begin
    FSelColor32:=Value;
    FSelHSV.A:=AlphaComponent(Value);
    exit;
  end;
  FSelColor32:=Value;
  FSelHSV:=ARGBToAHSV(Value);
  UpdateSV;
  Paint;
end;

procedure THSVColorChooser.SetSelHSV(const Value: TAHSV);
begin
  FSelHSV:=Value;
  FSelColor32:=AHSVToARGB(Value);
  UpdateSV;
  Paint;
end;

procedure THSVColorChooser.SetHueWidth(Value: Integer);
begin
  FHueWidth:=Value;
  UpdateSize;
end;

function THSVColorChooser.GetBGColor: TColor;
begin
  Result:=Color;
end;

procedure THSVColorChooser.SetBGColor(Value: TColor);
begin
  Color:=Value;
  UpdateHue;
  Paint;
end;

{TAlphaBar}

constructor TAlphaBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlphaBuffer:=TBitmap.Create;
  FSelColor32:=$FFFF0000;
  FSqrColor1:=clWhite;
  FSqrColor2:=clBlack;
  FMouseIsDown:=false;
  FSquareSize:=6;
  UpdateColor;
end;

destructor TAlphaBar.Destroy;
begin
  FAlphaBuffer.Destroy;
  inherited Destroy;
end;

procedure TAlphaBar.UpdateColor;
var
  I,J,YCount       : Integer;
  //AC1,AC2          : TColor;
  AColor           : TColor32;
  AAlpha,AAlphaStep: Real;
  AIsC1            : Boolean;
  DrawColors       : array [Boolean] of TColor;
begin
  if (Width<11) or (Height<11) then exit;
  FAlphaBuffer.SetSize(Width-10,Height-10);
  with FAlphaBuffer do begin
    YCount:=Trunc(Height/FSquareSize)+1;
    AColor:=FSelColor32;
    AAlpha:=0.0;
    AAlphaStep:=$FF/Width;
    for I:=0 to Width-1 do begin
      SetColor32Alpha(Round(AAlpha),AColor);
      DrawColors[false]:=Color32ToColor(BlendAlpha(FSqrColor1,AColor));
      DrawColors[true]:=Color32ToColor(BlendAlpha(FSqrColor2,AColor));
      AIsC1:=Odd(I div FSquareSize);
      Canvas.MoveTo(I,0);
      for J:=1 to YCount do begin
        Canvas.Pen.Color:=DrawColors[AIsC1];
        Canvas.LineTo(I,J*FSquareSize);
        AIsC1:=not AIsC1;
      end;
      AAlpha+=AAlphaStep;
    end;
  end;
end;

procedure TAlphaBar.Paint;
var
  AAlphaPos: Integer;
begin
  Canvas.Brush.Color:=Color;
  Canvas.Pen.Color:=Color;
  Canvas.Rectangle(0,0,Width,Height);
  Canvas.Draw(5,5,FAlphaBuffer);
  Canvas.Pen.Width:=2;
  Canvas.Pen.Color:=clBlack;
  Canvas.Brush.Style:=bsClear;
  AAlphaPos:=5+Round(AlphaComponent(FSelColor32)*(FAlphaBuffer.Width/$FF));
  Canvas.Rectangle(AAlphaPos-4,1,AAlphaPos+4,Height-1);
  canvas.Brush.Style:=bsSolid;
end;

procedure TAlphaBar.Resize;
begin
  UpdateColor;
end;

procedure TAlphaBar.MouseMove(Shift: TShiftState; X,Y: Integer);
begin
  inherited MouseMove(Shift,X,Y);
  if not Enabled then exit;
  if FMouseIsDown then begin
    if X<5 then SetColor32Alpha(0,FSelColor32) else begin
      if X>FAlphaBuffer.Width+5
        then SetColor32Alpha($FF,FSelColor32)
        else SetColor32Alpha(Round(($FF/FAlphaBuffer.Width)*(X-5)),FSelColor32);
    end;
    UpdateColor;
    Paint;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TAlphaBar.MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  if TabStop then SetFocus;
  FMouseIsDown:=true;
  MouseMove(Shift,X,Y);
end;

procedure TAlphaBar.MouseUp(Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
begin
  inherited MouseUp(Button,Shift,X,Y);
  MouseMove(Shift,X,Y);
  FMouseIsDown:=false;
end;

function TAlphaBar.GetSelColor: TColor;
begin
  Result:=Color32ToColor(FSelColor32);
end;

procedure TAlphaBar.SetSelColor(Value: TColor);
begin
  SetColor32Color(Value,FSelColor32);
  UpdateColor;
  Paint;
end;

procedure TAlphaBar.SetSelColor32(Value: TColor32);
begin
  FSelColor32:=Value;
  UpdateColor;
  Paint;
end;

function TAlphaBar.GetSelAlpha: Byte;
begin
  Result:=AlphaComponent(FSelColor32);
end;

procedure TAlphaBar.SetSelAlpha(Value: Byte);
begin
  SetColor32Alpha(Value,FSelColor32);
  Paint;
end;

procedure TAlphaBar.SetSquareSize(Value: Integer);
begin
  FSquareSize:=Value;
  UpdateColor;
  Paint;
end;

procedure TAlphaBar.SetSqrColor1(Value: TColor);
begin
  FSqrColor1:=Value;
  UpdateColor;
  Paint;
end;

procedure TAlphaBar.SetSqrColor2(Value: TColor);
begin
  FSqrColor2:=Value;
  UpdateColor;
  Paint;
end;

{TGridColorChooser}

constructor TGridColorChooser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBuffer:=TBitmap.Create;
  FAlphaWidth:=6;
  FAlphaHeight:=6;
  FColorWidth:=20;
  FColorHeight:=15;
  FColorDist:=3;
  FColorsPerRow:=1;
  FAlphaColor1:=clWhite;
  FAlphaColor2:=clBlack;
  FColorIndex:=-1;
  FMouseOverIndex:=-1;
  FSelColor32:=$00000000;
  Color:=clBtnFace;
  FUpdating:=false;
  FChanged:=false;
end;

destructor TGridColorChooser.Destroy;
begin
  FBuffer.Destroy;
  inherited Destroy;
end;

procedure TGridColorChooser.StartUpdate;
begin
  FUpdating:=true;
end;

procedure TGridColorChooser.EndUpdate;
begin
  FUpdating:=false;
  UpdateColors;
  if (FColorIndex>=0) and (FColorIndex<Length(FColors)) then begin
    if FColors[FColorIndex]<>FSelColor32 then UpdateColorIndex;
  end else UpdateColorIndex;
  Paint;
end;

procedure TGridColorChooser.Paint;
var
  ARect: TRect;
begin
  if FUpdating then exit;
  inherited Paint;
  Canvas.Draw(0,0,FBuffer);
  if FMouseOverIndex>=0 then SelectionRect(FMouseOverIndex,Canvas,ARect,$BBBBBB,$888888);
  if FColorIndex>=0 then SelectionRect(FColorIndex,Canvas,ARect,$555555,$222222);
end;

procedure TGridColorChooser.Resize;
begin
  inherited Resize;
  FBuffer.SetSize(Width,Height);
  UpdateColors;
end;

procedure TGridColorChooser.MouseMove(Shift: TShiftState; X,Y: Integer);
var
  ACSX,ACSY,AOldIndex: Integer;
begin
  inherited MouseMove(Shift,X,Y);
  AOldIndex:=FMouseOverIndex;
  ACSX:=FColorWidth+FColorDist;
  ACSY:=FColorHeight+FColorDist;
  if (X mod ACSX>FColorDist) and (Y mod ACSY>FColorDist) then begin
    FMouseOverIndex:=(Y div ACSY)*FColorsPerRow+(X div ACSX);
    if FMouseOverIndex>=Length(FColors) then FMouseOverIndex:=-1
  end else FMouseOverIndex:=-1;
  if FMouseOverIndex<>AOldIndex then Paint;
end;

procedure TGridColorChooser.MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  if TabStop then SetFocus;
  if (FMouseOverIndex>=0) and (FColorIndex<>FMouseOverIndex) then begin
    FColorIndex:=FMouseOverIndex;
    FSelColor32:=FColors[FMouseOverIndex];
    if Assigned(FOnChange) then FOnChange(Self);
    FChanged:=true;
    Paint;
  end;
end;

procedure TGridColorChooser.MouseUp(Button: TMouseButton; Shift:TShiftState; X,Y:Integer);
begin
  inherited MouseUp(Button,Shift,X,Y);
  if FChanged then begin
    if Assigned(FOnChanged) then FOnChanged(Self);
    FChanged:=false;
  end;
end;

procedure TGridColorChooser.MouseLeave;
begin
  inherited MouseLeave;
  FMouseOverIndex:=-1;
end;

procedure TGridColorChooser.CheckColorIndex(Index: Integer);
begin
  if FUpdating then exit;
  if FColorIndex=Index then begin
    if FSelColor32<>FColors[Index] then UpdateColorIndex;
  end else begin
    if FColorIndex<0 then if FSelColor32=FColors[Index] then FColorIndex:=Index;
  end;
end;

procedure TGridColorChooser.UpdateColorIndex;
var
  I: Integer;
begin
  if FUpdating then exit;
  for I:=0 to Length(FColors)-1 do if FColors[I]=FSelColor32 then begin
    FColorIndex:=I;
    exit;
  end;
  FColorIndex:=-1;
end;

procedure TGridColorChooser.SelectionRect(Index: Integer; ACanvas: TCanvas; var ARect: TRect; AC1,AC2: TColor);
begin
  with ARect do begin
    Left:=(Index mod FColorsPerRow)*(FColorDist+FColorWidth)+FColorDist;
    Top:=(Index div FColorsPerRow)*(FColorDist+FColorHeight)+FColorDist;
    Right:=Left+FColorWidth;
    Bottom:=Top+FColorHeight;
  end;
  Canvas.Pen.Color:=AC1;
  Canvas.Brush.Style:=bsClear;
  Canvas.Rectangle(Classes.Rect(ARect.Left+1,ARect.Top+1,ARect.Right-1,ARect.Bottom-1));
  Canvas.Pen.Color:=AC2;
  Canvas.Rectangle(ARect);
  Canvas.Brush.Style:=bsSolid;
end;

procedure TGridColorChooser.UpdateColor(Index: Cardinal);
var
  ARect: TRect;
begin
  if FUpdating then exit;
  with FBuffer do begin
    SelectionRect(Index,Canvas,ARect,$888888,$555555);
    DrawAlphaColorArea(Canvas,Classes.Rect(ARect.Left+2,ARect.Top+2,ARect.Right-2,ARect.Bottom-2),FColors[Index],FAlphaColor1,FAlphaColor2,FAlphaWidth,FAlphaHeight);
  end;
end;

procedure TGridColorChooser.UpdateColors;
var
  I    : Integer;
  ARect: TRect;
begin
  if FUpdating then exit;
  with FBuffer do begin
    Canvas.Pen.Color:=Color;
    Canvas.Brush.Color:=Color;
    Canvas.Rectangle(0,0,Width,Height);
    if Width>=FColorWidth+FColorDist
      then FColorsPerRow:=Width div (FColorWidth+FColorDist)
      else FColorsPerRow:=1;
    with ARect do begin
      Bottom:=0;
      Canvas.Pen.Color:=clBlack;
      for I:=0 to Length(FColors)-1 do begin
        if I mod FColorsPerRow>0 then begin
          Left:=Right+FColorDist;
          Right:=Left+FColorWidth;
        end else begin
          Left:=FColorDist;
          Right:=Left+FColorWidth;
          Top:=Bottom+FColorDist;
          Bottom:=Top+FColorHeight;
        end;
        Canvas.Pen.Color:=$CCCCCC;
        Canvas.Brush.Style:=bsClear;
        Canvas.Rectangle(Classes.Rect(ARect.Left+1,ARect.Top+1,ARect.Right-1,ARect.Bottom-1));
        Canvas.Pen.Color:=$AAAAAA;
        Canvas.Rectangle(ARect);
        Canvas.Brush.Style:=bsSolid;
        DrawAlphaColorArea(Canvas,Classes.Rect(ARect.Left+2,ARect.Top+2,ARect.Right-2,ARect.Bottom-2),FColors[I],FAlphaColor1,FAlphaColor2,FAlphaWidth,FAlphaHeight);
      end;
    end;
  end;
end;

function TGridColorChooser.GetColorItem(Index: Integer): TColor;
begin
  Result:=Color32ToColor(FColors[Index]);
end;

procedure TGridColorChooser.SetColorItem(Index: Integer; Value: TColor);
begin
  SetColor32Color(Value,FColors[Index]);
  UpdateColor(Index);
  CheckColorIndex(Index);
  Paint;
end;

function TGridColorChooser.GetColor32Item(Index: Integer): TColor32;
begin
  Result:=FColors[Index];
end;

procedure TGridColorChooser.SetColor32Item(Index: Integer; Value: TColor32);
begin
  FColors[Index]:=Value;
  UpdateColor(Index);
  CheckColorIndex(Index);
  Paint;
end;

function TGridColorChooser.GetAlphaItem(Index: Integer): Byte;
begin
  Result:=AlphaComponent(FColors[Index]);
end;

procedure TGridColorChooser.SetAlphaItem(Index: Integer; Value: Byte);
begin
  SetColor32Alpha(Value,FColors[Index]);
  UpdateColor(Index);
  CheckColorIndex(Index);
  Paint;
end;

function TGridColorChooser.GetCount: Integer;
begin
  Result:=Length(FColors);
end;

procedure TGridColorChooser.SetCount(Value: Integer);
var
  I,L: Integer;
begin
  L:=Length(FColors);
  SetLength(FColors,Value);
  for I:=L to Value-1 do FColors[I]:=$FFFFFFFF;
  UpdateColors;
  UpdateColorIndex;
  Paint;
end;

procedure TGridColorChooser.SetColorWidth(Value: Integer);
begin
  if Value<=0 then exit;
  FColorWidth:=Value;
  UpdateColors;
  Paint;
end;

procedure TGridColorChooser.SetColorHeight(Value: Integer);
begin
  if Value<=0 then exit;
  FColorHeight:=Value;
  UpdateColors;
  Paint;
end;

procedure TGridColorChooser.SetAlphaWidth(Value: Integer);
begin
  FAlphaWidth:=Value;
  UpdateColors;
  Paint;
end;

procedure TGridColorChooser.SetAlphaHeight(Value: Integer);
begin
  FAlphaHeight:=Value;
  UpdateColors;
  Paint;
end;

procedure TGridColorChooser.SetColorDist(Value: Integer);
begin
  FColorDist:=Value;
  UpdateColors;
  Paint;
end;

procedure TGridColorChooser.SetAlphaColor1(Value: TColor);
begin
  FAlphaColor1:=Value;
  UpdateColors;
  Paint;
end;

procedure TGridColorChooser.SetAlphaColor2(Value: TColor);
begin
  FAlphaColor2:=Value;
  UpdateColors;
  Paint;
end;

function TGridColorChooser.GetBGColor: TColor;
begin
  Result:=Color;
end;

procedure TGridColorChooser.SetBGColor(Value: TColor);
begin
  Color:=Value;
  UpdateColors;
  Paint;
end;

procedure TGridColorChooser.SetColorIndex(Value: Integer);
begin
  if (Value>=Length(FColors)) or (Value<0) then begin
    if FColorIndex>=0 then FSelColor32:=$00000000;
    FColorIndex:=-1;
  end else begin
    FColorIndex:=Value;
    FSelColor32:=FColors[Value];
  end;
  Paint;
end;

procedure TGridColorChooser.SetSelColor32(Value: TColor32);
begin
  if FSelColor32=Value then exit;
  FSelColor32:=Value;
  UpdateColorIndex;
  Paint;
end;

function TGridColorChooser.GetSelColor: TColor;
begin
  Result:=Color32ToColor(FSelColor32);
end;

procedure TGridColorChooser.SetSelColor(Value: TColor);
begin
  if Color32ToColor(FSelColor32)=Value then exit;
  SetColor32Color(Value,FSelColor32);
  UpdateColorIndex;
  Paint;
end;

function TGridColorChooser.GetSelAlpha: Byte;
begin
  Result:=AlphaComponent(FSelColor32);
end;

procedure TGridColorChooser.SetSelAlpha(Value: Byte);
begin
  if AlphaComponent(FSelColor32)=Value then exit;
  SetColor32Alpha(Value,FSelColor32);
  UpdateColorIndex;
  Paint;
end;

{Algemein}

procedure Register;
begin
  RegisterComponents('Erweitert',[THSVColorChooser,TAlphaBar,TGridColorChooser]);
end;

end.

