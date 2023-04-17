unit CanvasGraphX32;

{$mode objfpc}{$H+}

interface

uses
  Classes, GraphX32, Graphics;

type
  TRectEdge  = (reTopLeft, reTopRight, reBottomLeft, reBottomRight);
  TRectEdges = set of TRectEdge;

procedure DrawAlphaColorArea(Canvas: TCanvas; Rect: TRect; Color: TColor32; AC1: TColor = clWhite; AC2: TColor = clBlack; AlphaSizeX: Integer = 4; AlphaSizeY: Integer = 4);
procedure DrawChessRects(Canvas: TCanvas; Rect: TRect; Color1,Color2: TColor; RectSize: TPoint);
procedure DrawRect(Canvas: TCanvas; X1,Y1,X2,Y2: Integer); inline;
procedure DrawRect(Canvas: TCanvas; ARect: TRect); inline;
procedure DrawCutRect(Canvas: TCanvas; X1,Y1,X2,Y2,RX,RY: Integer); inline;
//x1,y1 is the top left edge...
procedure DrawPartlyCutRect(Canvas: TCanvas; X1,Y1,X2,Y2,RX,RY: Integer; AEdges: TRectEdges); inline;

implementation


procedure DrawAlphaColorArea(Canvas: TCanvas; Rect: TRect; Color: TColor32; AC1: TColor = clWhite; AC2: TColor = clBlack; AlphaSizeX: Integer = 4; AlphaSizeY: Integer = 4);
begin
  DrawChessRects(Canvas,Rect,Color32ToColor(BlendAlpha(ColorToColor32(AC1),Color)),Color32ToColor(BlendAlpha(ColorToColor32(AC2),Color)),Point(AlphaSizeX,AlphaSizeY));
end;

procedure DrawChessRects(Canvas: TCanvas; Rect: TRect; Color1,Color2: TColor; RectSize: TPoint);
var
  J,XCount,YCount,XAdd,YAdd: Integer;
  IsFirstColor             : Boolean;
  AColors                  : array [Boolean] of TColor;
  ARect                    : TRect;

  procedure DrawXRow;
  var
    I: Integer;
  begin
    for I:=0 to XCount-1 do begin
      with ARect do begin
        Left:=Right;
        Right+=RectSize.X;
      end;
      with Canvas do begin
        Brush.Color:=AColors[IsFirstColor];
        Pen.Color:=Brush.Color;
        Rectangle(ARect);
      end;
      IsFirstColor:=not IsFirstColor;
    end;
    with ARect do begin
      Left:=Right;
      Right+=XAdd;
    end;
    with Canvas do begin
      Brush.Color:=AColors[IsFirstColor];
      Pen.Color:=Brush.Color;
      Rectangle(ARect);
    end;
  end;

begin
  if Color1=Color2 then begin
    Canvas.Pen.Color:=Color1;
    Canvas.Brush.COlor:=Color2;
    Canvas.Rectangle(Rect);
    exit;
  end;

  AColors[true]:=Color1;
  AColors[false]:=Color2;
  XAdd:=Rect.Right-Rect.Left;
  YAdd:=Rect.Bottom-Rect.Top;
  XCount:=XAdd div RectSize.X;
  YCount:=YAdd div RectSize.Y;
  XAdd:=XAdd mod RectSize.X;
  YAdd:=YAdd mod RectSize.Y;
  ARect.Bottom:=Rect.Top;
  Canvas.Pen.Width:=1;

  for J:=0 to YCount-1 do begin
    IsFirstColor:=Odd(J);
    with ARect do begin
      Right:=Rect.Left;
      Top:=Bottom;
      Bottom+=RectSize.Y;
    end;
    DrawXRow;
  end;

  if YAdd>0 then begin
    IsFirstColor:=Odd(YCount);
    with ARect do begin
      Right:=Rect.Left;
      Top:=Bottom;
      Bottom+=YAdd;
    end;
    DrawXRow;
  end;
end;

procedure DrawRect(Canvas: TCanvas; X1,Y1,X2,Y2: Integer); inline;
begin
  Canvas.Rectangle(X1, Y1, X2+1, Y2+1);
end;

procedure DrawRect(Canvas: TCanvas; ARect: TRect); inline;
begin
  Canvas.Rectangle(ARect.Left, ARect.Top, ARect.Right+1, ARect.Bottom+1);
end;

procedure DrawCutRect(Canvas: TCanvas; X1,Y1,X2,Y2,RX,RY: Integer); inline;
begin
  Canvas.Polygon([
    Point(X1+RX, Y1),
    Point(X2-RX, Y1),
    Point(X2, Y1+RY),
    Point(X2, Y2-RY),
    Point(X2-RX, Y2),
    Point(X1+RX, Y2),
    Point(X1, Y2-RY),
    Point(X1, Y1+RY)
  ]);
end;

procedure DrawPartlyCutRect(Canvas: TCanvas; X1,Y1,X2,Y2,RX,RY: Integer; AEdges: TRectEdges); inline;
var
  APoints: array of TPoint;
  L      : Integer;

  procedure AddPoint(X, Y: Integer); inline;
  begin
    APoints[L]:=Point(X, Y);
    Inc(L);
  end;

begin
  SetLength(APoints, 8);
  L:=0;
  if reTopLeft in AEdges then begin
    AddPoint(X1, Y1+RY);
    AddPoint(X1+RX, Y1);
  end else AddPoint(X1, Y1);
  if reTopRight in AEdges then begin
    AddPoint(X2-RX, Y1);
    AddPoint(X2, Y1+RY);
  end else AddPoint(X2, Y1);
  if reBottomRight in AEdges then begin
    AddPoint(X2, Y2-RY);
    AddPoint(X2-RX, Y2);
  end else AddPoint(X2, Y2);
  if reBottomLeft in AEdges then begin
    AddPoint(X1+RX, Y2);
    AddPoint(X1, Y2-RY);
  end else AddPoint(X1, Y2);
  SetLength(APoints, L);
  Canvas.Polygon(APoints);
  SetLength(APoints, 0);
end;

end.

