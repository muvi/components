unit AdvCoord;

{$mode objfpc}{$H+}

interface

uses
  Classes, Math;

type
  TPhiR         = record
    R,Phi: Real;
  end;

  TRealPoint    = record
    X,Y: Real;
  end;

  TRealRect     = record
    Left,Top,Right,Bottom: Real;
  end;

  TRR           = record
    RP1,RP2: Real;
  end;

  TBoundsRect   = packed object
  strict private
    function GetHeight: Integer; inline;
    function GetWidth: Integer; inline;
    function GetSize: TPoint; inline;
    procedure SetHeight(Value: Integer); inline;
    procedure SetLeft(Value: Integer); inline;
    procedure SetTop(Value: Integer); inline;
    procedure SetWidth(Value: Integer); inline;
    procedure SetPos(Value: TPoint); inline;
    procedure SetSize(Value: TPoint); inline;
  public
    Rect: TRect;
    procedure SetBounds(ALeft,ATop,AWidth,AHeight: Integer); inline;
    property Height: Integer read GetHeight write SetHeight;
    property Left: Integer read Rect.Left write SetLeft;
    property Pos: TPoint read Rect.TopLeft write SetPos;
    property Size: TPoint read GetSize write SetSize;
    property Top: Integer read Rect.Top write SetTop;
    property Width: Integer read GetWidth write SetWidth;
  end;

  PRect         = ^TRect;
  PRealRect     = ^TRealRect;
  PPoint        = ^TPoint;
  PRealPoint    = ^TRealPoint;
  PBoundsRect   = ^TBoundsRect;

const
  ZEROCENTER: TRealPoint = (X:Real(0.0);Y:Real(0.0));
  ZEROPOINT : TPoint = (X: 0; Y: 0);
  ZERORECT  : TRect = (Left:0;Top:0;Right:0;Bottom:0);

operator := (m: TRect) r: TBoundsRect;
operator := (m: TBoundsRect) r: TRect;

function RealPoint(const X,Y: Real): TRealPoint; overload;
function RealPoint(const P: TPoint): TRealPoint; overload;
function RealPoint(const PR: TPhiR; const Center: TRealPoint): TRealPoint; overload;
function RealPoint(const PR: TPhiR; const Center: TPoint): TRealPoint; overload;
function PhiR(const R,Phi: Real): TPhiR; overload;
function PhiR(const P: TRealPoint; const Center: TRealPoint): TPhiR; overload;
function PhiR(const P: TRealPoint; const Center: TPoint): TPhiR; overload;
function PhiR(const P: TPoint; const Center: TRealPoint): TPhiR; overload;
function PhiR(const P: TPoint; const Center: TPoint): TPhiR; overload;
function Point(const P: TRealPoint): TPoint; overload;
function Rect(const ARect: TRealRect): TRect; overload;
function Rect(APos: TPoint; ASize: TPoint): TRect; overload;
function RealRect(const ARect: TRect): TRealRect; inline; overload;
function RealRect(ALeft,ATop,ARight,ABottom: Real): TRealRect; inline; overload;
function CutPoint(const RP1,RP2: Real; const P1,P2: TRealPoint): TRealPoint; overload;
function arccos2(const Y,X: Real): Real;
(*
  calculates the angle between two lines of the length R1 and R2, when BowAngle
  is the length of a circular bow which starts with the Radius R1 and goes
  linear to the Radius R2
*)
function RToPhi(R1,R2,BowLength: Real): Real;
(*
  In a triangle where the length of the 3 sides is given with a, b and
  opposite, the function returns the angle on the opposite side of opposite
  Caution: only defined, if opposite<=a+b
*)
function TriangleAngle(a, b, opposite: Real): Real;
function Distance(const P1,P2: TRealPoint): Real; inline;
function Distance(const P1,P2: TPoint): Real; inline;
function BoundsRect(ALeft,ATop,AWidth,AHeight: Integer): TBoundsRect; inline;
function FitTo(Rect,FitInto: TRect): TRect;

operator + (const m1,m2: TRealPoint) r: TRealPoint;
operator - (const m1,m2: TRealPoint) r: TRealPoint;
operator + (const m1: TPoint; const m2: TRealPoint) r: TRealPoint;
operator * (const m1: TRealPoint; m2: Real) r: TRealPoint;
operator * (m1: Real; const m2: TRealPoint) r: TRealPoint;
operator / (const m1: TRealPoint; m2: Real) r: TRealPoint;
operator * (const m1: TPoint; m2: Real) r: TRealPoint;
operator * (m1: Real; const m2: TPoint) r: TRealPoint;
operator / (const m1: TPoint; m2: Real) r: TRealPoint;
operator * (const m1: TRealRect; m2: Real): TRealRect;
operator * (m1: Real; const m2: TRealRect): TRealRect;
operator / (const m1: TRealRect; m2: Real): TRealRect;
operator = (const m1,m2: TRealPoint) r: Boolean;
operator = (const m1,m2: TPoint) r: Boolean;
operator = (const m1,m2: TRect): Boolean;
operator = (const m1,m2: TRealRect): Boolean;
operator + (const m1,m2: TPoint) r: TPoint;
operator - (const m1,m2: TPoint) r: TPoint;
operator - (const m1: TPoint) r: TPoint;
operator + (const m1: TRealPoint; const m2: TPoint) r: TRealPoint;
operator - (const m1: TRealPoint; const m2: TPoint) r: TRealPoint;
operator + (const m1: TRect; const m2: TPoint) r: TRect;
operator - (const m1: TRect; const m2: TPoint) r: TRect;
operator + (const m1: TRealRect; const m2: TRealPoint) r: TRealRect;
operator - (const m1: TRealRect; const m2: TRealPoint) r: TRealRect;

function InView(const ARect,ViewRect: TRect): Boolean;
function ToViewRect(const ARect,ViewRect: TRect): TRect;
function InRect(const P: TPoint; const R: TRect): Boolean;

operator >< (const m1,m2: TRect) r: Boolean;
operator >< (const m1: TPoint; const m2: TRect) r: Boolean;
operator < (const m1,m2: TPoint) r: Boolean;

implementation

{%REGION Points and Rects}

function RealPoint(const X,Y: Real): TRealPoint;
begin
  Result.X:=X;
  Result.Y:=Y;
end;

function RealPoint(const P: TPoint): TRealPoint;
begin
  Result.X:=P.X;
  Result.Y:=P.Y;
end;

function RealPoint(const PR: TPhiR; const Center: TRealPoint): TRealPoint;
begin
  with PR do begin
    Result.X:=(R*Sin(Phi))+Center.X;
    Result.Y:=(R*Cos(Phi))+Center.Y;
  end;
end;

function RealPoint(const PR: TPhiR; const Center: TPoint): TRealPoint;
begin
  with PR do begin
    Result.X:=(R*Sin(Phi))+Center.X;
    Result.Y:=(R*Cos(Phi))+Center.Y;
  end;
end;

function PhiR(const R,Phi: Real): TPhiR;
begin
  Result.R:=R;
  Result.Phi:=Phi;
end;

function PhiR(const P: TRealPoint; const Center: TRealPoint): TPhiR;
var
  PX,PY: Real;
begin
  PX:=P.X-Center.X;
  PY:=P.Y-Center.Y;
  Result.R:=sqrt(sqr(PX)+sqr(PY));
  Result.Phi:=ArcTan2(PY,PX);
end;

function PhiR(const P: TRealPoint; const Center: TPoint): TPhiR;
var
  PX,PY: Real;
begin
  PX:=P.X-Center.X;
  PY:=P.Y-Center.Y;
  Result.R:=sqrt(sqr(PX)+sqr(PY));
  Result.Phi:=ArcTan2(PY,PX);
end;

function PhiR(const P: TPoint; const Center: TRealPoint): TPhiR;
var
  PX,PY: Real;
begin
  PX:=P.X-Center.X;
  PY:=P.Y-Center.Y;
  Result.R:=sqrt(sqr(PX)+sqr(PY));
  Result.Phi:=ArcTan2(PY,PX);
end;

function PhiR(const P: TPoint; const Center: TPoint): TPhiR;
var
  PX,PY: Real;
begin
  PX:=P.X-Center.X;
  PY:=P.Y-Center.Y;
  Result.R:=sqrt(sqr(PX)+sqr(PY));
  Result.Phi:=ArcTan2(PY,PX);
end;

function Point(const P: TRealPoint): TPoint;
begin
  Result.X:=Round(P.X);
  Result.Y:=Round(P.Y);
end;

function Rect(const ARect: TRealRect): TRect;
begin
  with Result do begin
    Left:=Round(ARect.Left);
    Top:=Round(ARect.Top);
    Right:=Round(ARect.Right);
    Bottom:=Round(ARect.Bottom);
  end;
end;

function Rect(APos: TPoint; ASize: TPoint): TRect;
begin
  Result.TopLeft:=APos;
  Result.BottomRight:=APos+ASize;
end;

function RealRect(const ARect: TRect): TRealRect; inline; overload;
begin
  with Result do begin
    Left:=ARect.Left;
    Top:=ARect.Top;
    Right:=ARect.Right;
    Bottom:=ARect.Bottom;
  end;
end;

function RealRect(ALeft,ATop,ARight,ABottom: Real): TRealRect; inline; overload;
begin
  with Result do begin
    Left:=ALeft;
    Top:=ATop;
    Right:=ARight;
    Bottom:=ABottom;
  end;
end;

function arccos2(const Y,X: Real): Real;
begin
  Result:=arccos(Y/X);
  if Y<0 then Result:=-Result;
  if X<0 then Result+=Pi/2;
end;

function CutPoint(const RP1,RP2: Real; const P1,P2: TRealPoint): TRealPoint;
var
  a,h,sqrb,sqrc,beta,gamma: Real;
begin
  if IsZero(RP1) then begin
    Result:=P1;
    exit;
  end;
  if (IsZero(P2.X-P1.X) and IsZero(P2.Y-P1.Y)) then begin
    Result.X:=P1.X;
    Result.Y:=P1.Y+RP1;
    exit;
  end;
  a:=sqrt(sqr(P2.X-P1.X)+sqr(P2.Y-P1.Y));
  if RP1+RP2<a then begin
    Result:=P1;
    exit;
  end;
  sqrb:=sqr(RP2);
  sqrc:=sqr(RP1);
  h:=sqrt(sqrb-sqr((sqr(a)+sqrb-sqrc)/(2*a)));
  beta:=(Pi/2)-arccos2(h,RP1);
  gamma:=0;
  Result.X:=(RP1*sin(beta+gamma))+P1.X;
  Result.Y:=(RP1*cos(beta+gamma))+P1.Y;
end;

function RToPhi(R1,R2,BowLength: Real): Real;
begin
  {
  //big mystery: why did this work quite well with using senseless Sin
  //and other flaws?!
  BowLength2:=(R1/R2)*BowLength;
  Result:=Sin((BowLength2/2)/R1)*2;
  }
  //"Length" of a circle: 2*pi*r
  //this calculates the angle when the circular distance is BowLength
  Result:=((2*BowLength)/(R1+R2));
end;

function TriangleAngle(a, b, opposite: Real): Real;
begin
  if isZero(a) or isZero(b) or isZero(opposite)
    then Result:=0.0
    //Kosinussatz
    else Result:=Arccos((sqr(a)+sqr(b)-sqr(opposite))/(2.0*a*b));
end;

function Distance(const P1,P2: TRealPoint): Real; inline;
begin
  Result:=sqrt(sqr(P2.X-P1.X)+sqr(P2.Y-P1.Y));
end;

function Distance(const P1,P2: TPoint): Real; inline;
begin
  Result:=sqrt(sqr(P2.X-P1.X)+sqr(P2.Y-P1.Y));
end;

function BoundsRect(ALeft,ATop,AWidth,AHeight: Integer): TBoundsRect; inline;
begin
  Result.SetBounds(ALeft,ATop,AWidth,AHeight);
end;

{%ENDREGION}
{%REGION Operators}

operator + (const m1,m2: TRealPoint) r: TRealPoint;
begin
  with Result do begin
    X:=m1.X+m2.X;
    Y:=m1.Y+m2.Y;
  end;
end;

operator - (const m1,m2: TRealPoint) r: TRealPoint;
begin
  with Result do begin
    X:=m1.X-m2.X;
    Y:=m1.Y-m2.Y;
  end;
end;

operator + (const m1: TPoint; const m2: TRealPoint) r: TRealPoint;
begin
  with Result do begin
    X:=m1.X+m2.X;
    Y:=m1.Y+m2.Y;
  end;
end;

operator * (const m1: TRealPoint; m2: Real) r: TRealPoint;
begin
  with Result do begin
    X:=m1.X*m2;
    Y:=m1.Y*m2;
  end;
end;

operator * (m1: Real; const m2: TRealPoint) r: TRealPoint;
begin
  with Result do begin
    X:=m1*m2.X;
    Y:=m1*m2.Y;
  end;
end;

operator / (const m1: TRealPoint; m2: Real) r: TRealPoint;
begin
  with Result do begin
    X:=m1.X/m2;
    Y:=m1.Y/m2;
  end;
end;

operator * (const m1: TPoint; m2: Real) r: TRealPoint;
begin
  with Result do begin
    X:=m1.X*m2;
    Y:=m1.Y*m2;
  end;
end;

operator * (m1: Real; const m2: TPoint) r: TRealPoint;
begin
  with Result do begin
    X:=m1*m2.X;
    Y:=m1*m2.Y;
  end;
end;

operator / (const m1: TPoint; m2: Real) r: TRealPoint;
begin
  with Result do begin
    X:=m1.X/m2;
    Y:=m1.Y/m2;
  end;
end;

operator * (const m1: TRealRect; m2: Real): TRealRect;
begin
  with Result do begin
    Result.Left:=m1.Left*m2;
    Result.Top:=m1.Top*m2;
    Result.Right:=m1.Right*m2;
    Result.Bottom:=m1.Bottom*m2;
  end;
end;

operator * (m1: Real; const m2: TRealRect): TRealRect;
begin
  with Result do begin
    Result.Left:=m1*m2.Left;
    Result.Top:=m1*m2.Top;
    Result.Right:=m1*m2.Right;
    Result.Bottom:=m1*m2.Bottom;
  end;
end;

operator / (const m1: TRealRect; m2: Real): TRealRect;
begin
  with Result do begin
    Result.Left:=m1.Left/m2;
    Result.Top:=m1.Top/m2;
    Result.Right:=m1.Right/m2;
    Result.Bottom:=m1.Bottom/m2;
  end;
end;

operator = (const m1,m2: TRealPoint) r: Boolean;
begin
  Result:=(isZero(m1.X-m2.X)
    and isZero(m1.Y-m2.Y));
end;

operator = (const m1,m2: TPoint) r: Boolean;
begin
  Result:=((m1.X=m2.X)
    and (m1.Y=m2.Y));
end;

operator = (const m1,m2: TRect): Boolean;
begin
  Result:=((m1.Left=m2.Left) and (m1.Top=m2.Top) and (m1.Right=m2.Right) and (m1.Bottom=m2.Bottom));
end;

operator = (const m1,m2: TRealRect): Boolean;
begin
  Result:=((m1.Left=m2.Left) and (m1.Top=m2.Top) and (m1.Right=m2.Right) and (m1.Bottom=m2.Bottom));
end;

operator + (const m1,m2: TPoint) r: TPoint;
begin
  with Result do begin
    X:=m1.X+m2.X;
    Y:=m1.Y+m2.Y;
  end;
end;

operator - (const m1,m2: TPoint) r: TPoint;
begin
  with Result do begin
    X:=m1.X-m2.X;
    Y:=m1.Y-m2.Y;
  end;
end;

operator - (const m1: TPoint) r: TPoint;
begin
  with Result do begin
    X:=-m1.X;
    Y:=-m1.Y;
  end;
end;

operator + (const m1: TRealPoint; const m2: TPoint) r: TRealPoint;
begin
  with Result do begin
    X:=m1.X+m2.X;
    Y:=m1.Y+m2.Y;
  end;
end;

operator - (const m1: TRealPoint; const m2: TPoint) r: TRealPoint;
begin
  with Result do begin
    X:=m1.X-m2.X;
    Y:=m1.Y-m2.Y;
  end;
end;

operator + (const m1: TRect; const m2: TPoint) r: TRect;
begin
  Result.Left:=m1.Left+m2.X;
  Result.Top:=m1.Top+m2.Y;
  Result.Right:=m1.Right+m2.X;
  Result.Bottom:=m1.Bottom+m2.Y;
end;

operator - (const m1: TRect; const m2: TPoint) r: TRect;
begin
  Result.Left:=m1.Left-m2.X;
  Result.Top:=m1.Top-m2.Y;
  Result.Right:=m1.Right-m2.X;
  Result.Bottom:=m1.Bottom-m2.Y;
end;

operator + (const m1: TRealRect; const m2: TRealPoint) r: TRealRect;
begin
  Result.Left:=m1.Left+m2.X;
  Result.Top:=m1.Top+m2.Y;
  Result.Right:=m1.Right+m2.X;
  Result.Bottom:=m1.Bottom+m2.Y;
end;

operator - (const m1: TRealRect; const m2: TRealPoint) r: TRealRect;
begin
  Result.Left:=m1.Left-m2.X;
  Result.Top:=m1.Top-m2.Y;
  Result.Right:=m1.Right-m2.X;
  Result.Bottom:=m1.Bottom-m2.Y;
end;

{%ENDREGION}
{%REGION Collision}

function InView(const ARect,ViewRect: TRect): Boolean;
begin
  Result:=((ARect.Left<ViewRect.Right) and (ARect.Right>ViewRect.Left) and (ARect.Top<ViewRect.Bottom) and (ARect.Bottom>ViewRect.Top));
end;

function ToViewRect(const ARect,ViewRect: TRect): TRect;
begin
  Result.Left:=ARect.Left-ViewRect.Left;
  Result.Top:=ARect.Top-ViewRect.Top;
  Result.Right:=ARect.Right-ViewRect.Left;
  Result.Bottom:=ARect.Bottom-ViewRect.Top;
end;

function InRect(const P: TPoint; const R: TRect): Boolean;
begin
  Result:=((P.X>=R.Left) and (P.X<=R.Right) and (P.Y>=R.Top) and (P.Y<=R.Bottom));
end;

function FitTo(Rect,FitInto: TRect): TRect;
begin
  if Rect.Left<FitInto.Left
    then Result.Left:=FitInto.Left
    else Result.Left:=Rect.Left;
  if Rect.Top<FitInto.Top
    then Result.Top:=FitInto.Top
    else Result.Top:=Rect.Top;
  if Rect.Right>FitInto.Right
    then Result.Right:=FitInto.Right
    else Result.Right:=Rect.Right;
  if Rect.Bottom>FitInto.Bottom
    then Result.Bottom:=FitInto.Bottom
    else Result.Bottom:=Rect.Bottom;
end;

operator >< (const m1,m2: TRect) r: Boolean;
begin
  Result:=InView(m1,m2);
end;

operator >< (const m1: TPoint; const m2: TRect) r: Boolean;
begin
  Result:=InRect(m1,m2);
end;

operator := (m: TRect) r: TBoundsRect;
begin
  Result.Rect:=m;
end;

operator := (m: TBoundsRect) r: TRect;
begin
  Result:=m.Rect;
end;

operator < (const m1,m2: TPoint) r: Boolean;
begin
  Result:=((m1.X*m1.X)+(m1.Y*m1.Y)<(m2.X*m2.X)+(m2.Y*m2.Y));
end;

{%ENDREGION}
{%REGION TBoundsRect}

function TBoundsRect.GetHeight: Integer;
begin
  Result:=Rect.Bottom-Rect.Top+1;
end;

function TBoundsRect.GetWidth: Integer;
begin
  Result:=Rect.Right-Rect.Left+1;
end;

function TBoundsRect.GetSize: TPoint;
begin
  Result:=Point(Rect.Right-Rect.Left+1,Rect.Bottom-Rect.Top+1);
end;

procedure TBoundsRect.SetHeight(Value: Integer);
begin
  Rect.Bottom:=Rect.Top+Value-1;
end;

procedure TBoundsRect.SetLeft(Value: Integer);
begin
  with Rect do begin
    Right:=Right-Left+Value;
    Left:=Value;
  end;
end;

procedure TBoundsRect.SetTop(Value: Integer);
begin
  with Rect do begin
    Bottom:=Bottom-Top+Value;
    Top:=Value;
  end;
end;

procedure TBoundsRect.SetWidth(Value: Integer);
begin
  Rect.Right:=Rect.Left+Value;
end;

procedure TBoundsRect.SetPos(Value: TPoint);
begin
  with Rect do begin
    Right:=Right-Left+Value.X;
    Left:=Value.X;
    Bottom:=Top-Bottom+Value.Y;
    Top:=Value.Y;
  end;
end;

procedure TBoundsRect.SetSize(Value: TPoint);
begin
  with Rect do begin
    Right:=Left+Value.X-1;
    Bottom:=Top+Value.Y-1;
  end;
end;

procedure TBoundsRect.SetBounds(ALeft,ATop,AWidth,AHeight: Integer);
begin
  with Rect do begin
    Left:=ALeft;
    Right:=ALeft+AWidth-1;
    Top:=ATop;
    Bottom:=ATop+AHeight-1;
  end;
end;

{%ENDREGION}

end.

