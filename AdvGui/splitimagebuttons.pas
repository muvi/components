unit SplitImageButtons;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, AdvCoord, Dialogs;

procedure SplitImageH(Src,ALeft,AMiddle,ARight: TBitmap);
procedure SplitImageV(Src,ATop,AMiddle,ABottom: TBitmap);
procedure DrawSIButtonH(ACanvas: TCanvas; AViewRect: TRect; ALeft,AMiddle,ARight: TBitmap; X,Y,AWidth: Integer);
procedure DrawSIButtonV(ACanvas: TCanvas; AViewRect: TRect; ATop,AMiddle,ABottom: TBitmap; X,Y,AHeight: Integer);
procedure SIBtnImgH(Dest,ALeft,AMiddle,ARight: TBitmap; AWidth: Integer);
procedure SIBtnImgV(Dest,ATop,AMiddle,ABottom: TBitmap; AHeight: Integer);

implementation

procedure Transparentize(Bmp: TBitmap; AColor: TColor);
begin
  with Bmp do begin
    with Canvas do begin
      Brush.Color:=AColor;
      Pen.Color:=AColor;
      Rectangle(0,0,Width,Height);
      //doppelt wegen Lazarus Bug
      Rectangle(0,0,Width,Height);
    end;
    TransparentColor:=AColor;
    Transparent:=true;
  end;
end;

procedure SplitImageH(Src,ALeft,AMiddle,ARight: TBitmap);
var
  AW2             : Integer;
begin
  AW2:=Src.Width div 2;
  ALeft.SetSize(AW2,Src.Height);
  ARight.SetSize(AW2,Src.Height);
  AMiddle.SetSize(1,Src.Height);

  ALeft.Transparent:=Src.Transparent;
  ARight.Transparent:=Src.Transparent;
  AMiddle.Transparent:=Src.Transparent;
  if Src.Transparent then begin
    Transparentize(ALeft,Src.TransparentColor);
    Transparentize(ARight,Src.TransparentColor);
    Transparentize(AMiddle,Src.TransparentColor);
  end;

  ALeft.Canvas.Draw(0,0,Src);
  ARight.Canvas.Draw(ARight.Width-Src.Width,0,Src);
  AMiddle.Canvas.Draw(ARight.Width-Src.Width+1,0,Src);
end;

procedure SplitImageV(Src,ATop,AMiddle,ABottom: TBitmap);
var
  AH2             : Integer;
begin
  AH2:=Src.Height div 2;
  ATop.SetSize(Src.Width,AH2);
  ABottom.SetSize(Src.Width,AH2);
  AMiddle.SetSize(Src.Width,1);

  ATop.Transparent:=Src.Transparent;
  ABottom.Transparent:=Src.Transparent;
  AMiddle.Transparent:=Src.Transparent;
  if Src.Transparent then begin
    Transparentize(ATop,Src.TransparentColor);
    Transparentize(ABottom,Src.TransparentColor);
    Transparentize(AMiddle,Src.TransparentColor);
  end;

  ATop.Canvas.Draw(0,0,Src);
  ABottom.Canvas.Draw(0,ABottom.Height-Src.Height,Src);
  AMiddle.Canvas.Draw(0,ABottom.Height-Src.Height+1,Src);
end;

procedure DrawSIButtonH(ACanvas: TCanvas; AViewRect: TRect; ALeft,AMiddle,ARight: TBitmap; X,Y,AWidth: Integer);
var
  I,X1,X2,AY: Integer;
begin
  if (Y+AMiddle.Height<AViewRect.Top) or (Y>AViewRect.Bottom) or (X+AWidth<AViewRect.Left) or (X>AViewRect.Right) then exit;
  AY:=Y-AViewRect.Top;
  //Linkes Ende
  if X+ALeft.Width>=AViewRect.Left then begin
    ACanvas.Draw(X-AViewRect.Left,AY,ALeft);
    X1:=X+ALeft.Width-AViewRect.Left;
  end else X1:=0;
  //Rechtes Ende
  if X+AWidth-ARight.Width<AViewRect.Right then begin
    ACanvas.Draw(X+AWidth-ARight.Width-AViewRect.Left,AY,ARight);
    X2:=X+AWidth-ARight.Width-AViewRect.Left-1;
  end else X2:=AViewRect.Right-AViewRect.Left-1;
  //Mittelteile
  for I:=X1 to X2
    do ACanvas.Draw(I,AY,AMiddle);
end;

procedure DrawSIButtonV(ACanvas: TCanvas; AViewRect: TRect; ATop,AMiddle,ABottom: TBitmap; X,Y,AHeight: Integer);
var
  I,Y1,Y2,AX: Integer;
begin
  if (X+AMiddle.Width<AViewRect.Left) or (X>AViewRect.Right) or (Y+AHeight<AViewRect.Top) or (Y>AViewRect.Bottom) then exit;
  AX:=X-AViewRect.Left;
  //Oberes Ende
  if Y+ATop.Height>=AViewRect.Top then begin
    ACanvas.Draw(AX,Y-AViewRect.Top,ATop);
    Y1:=Y+ATop.Height-AViewRect.Top;
  end else Y1:=0;
  //Unteres Ende
  if Y+AHeight-ABottom.Height<AViewRect.Bottom then begin
    ACanvas.Draw(AX,Y+AHeight-ABottom.Height-AViewRect.Top,ABottom);
    Y2:=Y+AHeight-ABottom.Height-AViewRect.Top-1;
  end else Y2:=AViewRect.Bottom-AViewRect.Top-1;
  //Mittelteile
  for I:=Y1 to Y2
    do ACanvas.Draw(AX,I,AMiddle);
end;

procedure SIBtnImgH(Dest,ALeft,AMiddle,ARight: TBitmap; AWidth: Integer);
begin
  Dest.SetSize(AWidth,AMiddle.Height);
  Dest.Transparent:=ALeft.Transparent;
  if ALeft.Transparent
    then Transparentize(Dest,ALeft.TransparentColor);
  DrawSIButtonH(Dest.Canvas,Classes.Rect(0,0,Dest.Width,Dest.Height),ALeft,AMiddle,ARight,0,0,AWidth);
end;

procedure SIBtnImgV(Dest,ATop,AMiddle,ABottom: TBitmap; AHeight: Integer);
begin
  Dest.SetSize(AMiddle.Width,AHeight);
  Dest.Transparent:=ATop.Transparent;
  if ATop.Transparent
    then Transparentize(Dest,ATop.TransparentColor);
  DrawSIButtonV(Dest.Canvas,Classes.Rect(0,0,Dest.Width,Dest.Height),ATop,AMiddle,ABottom,0,0,AHeight);
end;

end.

