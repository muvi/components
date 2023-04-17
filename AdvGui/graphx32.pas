unit GraphX32;

{$mode objfpc}{$H+}

interface

uses
  //do not use LCL units here. Use CanvasGraphX32 instead.
  {$IFNDEF NOGRAPHICS}
  Graphics,
  {$ENDIF}
  AdvFunc;

type
  {$IFDEF NOGRAPHICS}
  TColor    = -$7FFFFFFF-1..$7FFFFFFF;
  {$ENDIF}

  TColor32  = type LongWord;
  PColor32  = ^TColor32;

  TRGB      = packed record
    R,G,B: Byte;
  end;

  PRGB      = ^TRGB;

  TBGR      = packed record
    B,G,R: Byte;
  end;

  PBGR      = ^TBGR;

  TXBGR     = packed record
    R,G,B,X: Byte;
  end;

  TARGB     = packed record
    B,G,R,A: Byte;
  end;

  THue      = Real;

  TAHSV     = record
    H    : THue;
    S,V,A: Byte;
  end;

  Byte9     = 0..511;
  Byte10    = 0..1023;
  Byte11    = 0..2047;
  Byte12    = 0..4095;

function ColorToColor32(Color: TColor; Alpha: Byte = $FF): TColor32; inline;
function Color32ToColor(Color: TColor32): TColor; inline;
function Color32ToRGB(AColor: TColor32): TRGB; inline;
function Color32ToBGR(AColor: TColor32): TBGR; inline;
function RGBToColor32(ARGB: TRGB; Alpha: Byte = $FF): TColor32; inline;
function Color32(r, g, b: Byte; a: Byte = 255): TColor32; inline;
function RedComponent(Color: TColor32): Byte; inline;
function GreenComponent(Color: TColor32): Byte; inline;
function BlueComponent(Color: TColor32): Byte; inline;
function AlphaComponent(Color: TColor32): Byte; inline;
procedure SetColor32Color(SrcColor: TColor; var DestColor: TColor32);
procedure SetColor32Color32(SrcColor: TColor32; var DestColor: TColor32);
procedure SetColor32Alpha(Alpha: Byte; var DestColor: TColor32);
//Works with TColor, too
function BlendAlpha(Color,Blend: TColor32): TColor32; overload;
function BlendAlpha(Alpha: Byte; Color1,Color2: TColor32): TColor32; overload;
function BlendAlpha(Alpha: Byte; Color1,Color2: TRGB): TRGB; overload;
function AlphaBlend(Alpha: Byte; Color1,Color2: TColor): TColor;
function AlphaBlendGray(Alpha: Byte; Color1: Byte; Color2: TColor32): TColor32;
function BetaBlend(const Color1,Color2: TColor32; const Beta: Byte): TColor32;
function TriBetaBlend(const Color1,Color2,Color3: TColor32; const Beta: Byte9): TColor32;
function MultiBetaBlend(const Colors: array of TColor32; const Beta: Cardinal): TColor32;
function MaxBeta(const Colors: Cardinal = 2): Cardinal;
procedure PiCut(var X: Real);
function ARGBToAHSV(AColor: TColor32): TAHSV;
function AHSVToARGB(AColor: TAHSV): TColor32;
function AHSV(_A: Byte; _H: THue; _S,_V: Byte): TAHSV; inline;
function ByteAdd(V1,V2: Byte): Integer; inline;
function ByteSubstract(V1,V2: Byte): Integer; inline;
function ClrAdd(AColor1,AColor2: TColor32): TColor32; inline;
function ClrAddWithoutAlpha(AColor1,AColor2: TColor32): TColor32; inline;
function ClrSubstract(AColor1,AColor2: TColor32): TColor32; inline;
function ClrSubstractWithoutAlpha(AColor1,AColor2: TColor32): TColor32; inline;
function Lighten(AColor: TColor32; AIntensity: Byte): TColor32; inline;
function Darken(AColor: TColor32; AIntensity: Byte): TColor32; inline;
function BGRDistance(AColor1,AColor2: TBGR): Integer; inline;
function ColorDistance(AColor1,AColor2: TColor32): Integer; inline;
procedure SetRGBColors(var AColors; ACount: Cardinal; AValue: TColor);

operator = (m1: TBGR; m2: TColor32) r: Boolean;
operator <> (m1: TBGR; m2: TColor32) r: Boolean;

const
  MaxHue: THue = 2*pi;

implementation

const
  HSVCA = pi/3; //2*pi/6
  HSVCA2= HSVCA*2;
  HSVCA4= HSVCA*4;

function ColorToColor32(Color: TColor; Alpha: Byte = $FF): TColor32; inline;
begin
  Result:=(Color and $0000FF00) or (Alpha shl 24) or ((Color and $00FF0000) shr 16) or ((Color and $000000FF) shl 16);
end;

function Color32ToColor(Color: TColor32): TColor; inline;
begin
  Result:=(Color and $0000FF00) or ((Color and $00FF0000) shr 16) or ((Color and $000000FF) shl 16);
end;

function Color32ToRGB(AColor: TColor32): TRGB; inline;
begin
  with Result do begin
    R:=(AColor shr 16) and $FF;
    G:=(AColor shr 8) and $FF;
    B:=AColor and $FF;
  end;
end;

function Color32ToBGR(AColor: TColor32): TBGR; inline;
var
  ABGR: TBGR absolute AColor;
begin
  Result:=ABGR;
end;

function RGBToColor32(ARGB: TRGB; Alpha: Byte = $FF): TColor32; inline;
begin
  with ARGB do Result:=(Alpha shl 24) or (R shl 16) or (G shl 8) or B;
end;

function Color32(r, g, b: Byte; a: Byte = 255): TColor32; inline;
begin
  Result:=(a shl 24) or (r shl 16) or (g shl 8) or b;
end;

function RedComponent(Color: TColor32): Byte; inline;
begin
  Result := (Color and $00FF0000) shr 16;
end;

function GreenComponent(Color: TColor32): Byte; inline;
begin
  Result := (Color and $0000FF00) shr 8;
end;

function BlueComponent(Color: TColor32): Byte; inline;
begin
  Result := Color and $000000FF;
end;

function AlphaComponent(Color: TColor32): Byte; inline;
begin
  Result := Color shr 24;
end;

procedure SetColor32Color(SrcColor: TColor; var DestColor: TColor32);
begin
  DestColor:=(DestColor and $FF000000) or (SrcColor and $0000FF00) or ((SrcColor and $00FF0000) shr 16) or ((SrcColor and $000000FF) shl 16);
end;

procedure SetColor32Color32(SrcColor: TColor32; var DestColor: TColor32);
begin
  DestColor:=(DestColor and $FF000000) or (SrcColor and $00FFFFFF);
end;

procedure SetColor32Alpha(Alpha: Byte; var DestColor: TColor32);
begin
  DestColor:=(DestColor and $00FFFFFF) or (Alpha shl 24);
end;

function BlendAlpha(Color,Blend: TColor32): TColor32;
var
  Color2 : TARGB absolute Color;
  Result2: TARGB absolute Result;
  Blend2 : TARGB absolute Blend;
begin
  Result2.R:=(Blend2.R*Blend2.A+Color2.R*($FF-Blend2.A)) div $FF;
  Result2.G:=(Blend2.G*Blend2.A+Color2.G*($FF-Blend2.A)) div $FF;
  Result2.B:=(Blend2.B*Blend2.A+Color2.B*($FF-Blend2.A)) div $FF;
  Result2.A:=Color2.A;
end;

function BlendAlpha(Alpha: Byte; Color1,Color2: TColor32): TColor32;
var
  Color1a: TARGB absolute Color1;
  Color2a: TARGB absolute Color2;
  Resulta: TARGB absolute Result;
begin
  Resulta.R:=(Color2a.R*Alpha+Color1a.R*($FF-Alpha)) div $FF;
  Resulta.G:=(Color2a.G*Alpha+Color1a.G*($FF-Alpha)) div $FF;
  Resulta.B:=(Color2a.B*Alpha+Color1a.B*($FF-Alpha)) div $FF;
  Resulta.A:=Color1a.A;
end;

function BlendAlpha(Alpha: Byte; Color1,Color2: TRGB): TRGB;
begin
  Result.R:=(Color2.R*Alpha+Color1.R*($FF-Alpha)) div $FF;
  Result.G:=(Color2.G*Alpha+Color1.G*($FF-Alpha)) div $FF;
  Result.B:=(Color2.B*Alpha+Color1.B*($FF-Alpha)) div $FF;
end;

function AlphaBlend(Alpha: Byte; Color1,Color2: TColor): TColor;
var
  AColor1: TXBGR absolute Color1;
  AColor2: TXBGR absolute Color2;
  AResult: TXBGR absolute Result;
begin
  AResult.R:=(AColor2.R*Alpha+AColor1.R*($FF-Alpha)) div $FF;
  AResult.G:=(AColor2.G*Alpha+AColor1.G*($FF-Alpha)) div $FF;
  AResult.B:=(AColor2.B*Alpha+AColor1.B*($FF-Alpha)) div $FF;
  AResult.X:=0;
end;

function AlphaBlendGray(Alpha: Byte; Color1: Byte; Color2: TColor32): TColor32;
var
  AColor2    : TARGB absolute Color2;
  AResult    : TARGB absolute Result;
  GrayBlended: Word;
begin
  GrayBlended:=Color1*($FF-Alpha);
  with AResult do begin
    R:=(AColor2.R*Alpha+GrayBlended) div $FF;
    G:=(AColor2.G*Alpha+GrayBlended) div $FF;
    B:=(AColor2.B*Alpha+GrayBlended) div $FF;
  end;
end;

function BetaBlend(const Color1,Color2: TColor32; const Beta: Byte): TColor32;
var
  AColor1: TARGB absolute Color1;
  AColor2: TARGB absolute Color2;
  Result2: TARGB absolute Result;
begin
  Result2.R:=(AColor1.R*Beta+AColor2.R*($FF-Beta)) div $FF;
  Result2.G:=(AColor1.G*Beta+AColor2.G*($FF-Beta)) div $FF;
  Result2.B:=(AColor1.B*Beta+AColor2.B*($FF-Beta)) div $FF;
  Result2.A:=(AColor1.A*Beta+AColor2.A*($FF-Beta)) div $FF;
end;

function TriBetaBlend(const Color1,Color2,Color3: TColor32; const Beta: Byte9): TColor32;
begin
  if Beta<$100
    then Result:=BetaBlend(Color1,Color2,Beta)
    else Result:=BetaBlend(Color2,Color3,Beta-$100);
end;

function MultiBetaBlend(const Colors: array of TColor32; const Beta: Cardinal): TColor32;
var
  AIndex: Cardinal;
begin
  AIndex:=Beta div $100;
  Result:=BetaBlend(Colors[AIndex],Colors[AIndex+1],Beta mod $100);
end;

function MaxBeta(const Colors: Cardinal = 2): Cardinal;
begin
  Result:=($100*(Colors-1))-1;
end;

procedure PiCut(var X: Real);
begin
  if X>Pi
    then X-=(Round(X/Pi)+1)*Pi
    else if X<-Pi
      then X+=(-Round(X/Pi)+1)*Pi
end;

function ARGBToAHSV(AColor: TColor32): TAHSV;
var
  AColor2  : TARGB absolute AColor;
  {AMax,}AMin: Byte;
begin
  with AColor2 do begin
    AMin:=IntMin([R,G,B]);
    //Alpha
    Result.A:=A;
    //Hue
    if (R=G) and (G=B) then begin
      Result.H:=0.0;
      Result.V:=R;
    end else begin
      if (R>=G) and (R>=B) then begin
        Result.V:=R;
        Result.H:=(HSVCA*((G-B)/(R-AMin)));
        if Result.H<0.0 then Result.H+=2*pi;
      end;
      if (G>=R) and (G>=B) then begin
        Result.V:=G;
        Result.H:=(HSVCA*((B-R)/(G-AMin)))+HSVCA2;
      end;
      if (B>=R) and (B>=G) then begin
        Result.V:=B;
        Result.H:=(HSVCA*((R-G)/(B-AMin)))+HSVCA4;
      end;
    end;
    //Saturation
    if Result.V>0
      then Result.S:=Round(((Result.V-AMin)/Result.V)*$FF)
      else Result.S:=0;
    //Value;
    //Result.V:=AMax;
  end;
end;

function AHSVToARGB(AColor: TAHSV): TColor32;
var
  AResult: TARGB absolute Result;
  hi     : Integer;
  f      : Real;

  function p: Byte; inline;
  begin
    //Result:=Round((AColor.V/$FF)*(1.0-(AColor.S/$FF))*$FF);
    Result:=AColor.V-((AColor.V*AColor.S) div $FF);
  end;

  function q: Byte; inline;
  begin
    //Result:=Round((AColor.V/$FF)*(1.0-((AColor.S/$FF)*f))*$FF);
    Result:=AColor.V-Round((AColor.V*AColor.S*f)/$FF);
  end;

  function t: Byte; inline;
  begin
    //Result:=Round((AColor.V/$FF)*(1.0-((AColor.S/$FF)*(1.0-f)))*$FF);
    Result:=AColor.V-Round((AColor.V*AColor.S*(1.0-f))/$FF);
  end;

begin
  with AColor do begin
    //Alpha
    AResult.A:=A;
    //RGB
    f:=H/HSVCA;
    hi:=Trunc(f);
    f-=hi;
    case hi of
      0,6: begin
          AResult.R:=V;
          AResult.G:=t;
          AResult.B:=p;
        end;
      1  : begin
          AResult.R:=q;
          AResult.G:=V;
          AResult.B:=p;
        end;
      2  : begin
          AResult.R:=p;
          AResult.G:=V;
          AResult.B:=t;
        end;
      3  : begin
          AResult.R:=p;
          AResult.G:=q;
          AResult.B:=V;
        end;
      4  : begin
          AResult.R:=t;
          AResult.G:=p;
          AResult.B:=V;
        end;
      5  : begin
          AResult.R:=V;
          AResult.G:=p;
          AResult.B:=q;
        end;
    end;
  end;
end;

function AHSV(_A: Byte; _H: THue; _S,_V: Byte): TAHSV; inline;
begin
  with Result do begin
    A:=_A;
    H:=_H;
    S:=_S;
    V:=_V;
  end;
end;

function ByteAdd(V1,V2: Byte): Integer; inline;
begin
  Result:=Integer(V1)+Integer(V2);
  if Result>$FF then Result:=$FF;
end;

function ByteSubstract(V1,V2: Byte): Integer; inline;
begin
  Result:=Integer(V1)-Integer(V2);
  if Result<0 then Result:=0;
end;

function ClrAdd(AColor1,AColor2: TColor32): TColor32; inline;
var
  AAColor1: TARGB absolute AColor1;
  AAColor2: TARGB absolute AColor2;
  AResult: TARGB absolute Result;
begin
  AResult.R:=ByteAdd(AAColor1.R,AAColor2.R);
  AResult.G:=ByteAdd(AAColor1.G,AAColor2.G);
  AResult.B:=ByteAdd(AAColor1.B,AAColor2.B);
  AResult.A:=ByteAdd(AAColor1.A,AAColor2.A);
end;

function ClrAddWithoutAlpha(AColor1,AColor2: TColor32): TColor32; inline;
var
  AAColor1: TARGB absolute AColor1;
  AAColor2: TARGB absolute AColor2;
  AResult: TARGB absolute Result;
begin
  AResult.R:=ByteAdd(AAColor1.R,AAColor2.R);
  AResult.G:=ByteAdd(AAColor1.G,AAColor2.G);
  AResult.B:=ByteAdd(AAColor1.B,AAColor2.B);
  AResult.A:=AAColor1.A;
end;

function ClrSubstract(AColor1,AColor2: TColor32): TColor32; inline;
var
  AAColor1: TARGB absolute AColor1;
  AAColor2: TARGB absolute AColor2;
  AResult: TARGB absolute Result;
begin
  AResult.R:=ByteSubstract(AAColor1.R,AAColor2.R);
  AResult.G:=ByteSubstract(AAColor1.G,AAColor2.G);
  AResult.B:=ByteSubstract(AAColor1.B,AAColor2.B);
  AResult.A:=ByteSubstract(AAColor1.A,AAColor2.A);
end;

function ClrSubstractWithoutAlpha(AColor1,AColor2: TColor32): TColor32; inline;
var
  AAColor1: TARGB absolute AColor1;
  AAColor2: TARGB absolute AColor2;
  AResult: TARGB absolute Result;
begin
  AResult.R:=ByteSubstract(AAColor1.R,AAColor2.R);
  AResult.G:=ByteSubstract(AAColor1.G,AAColor2.G);
  AResult.B:=ByteSubstract(AAColor1.B,AAColor2.B);
  AResult.A:=AAColor1.A;
end;

function Lighten(AColor: TColor32; AIntensity: Byte): TColor32; inline;
var
  AAColor : TARGB absolute AColor;
  AResult : TARGB absolute Result;
  AVal    : Integer;
  AR,AG,AB: Integer;
begin
  AR:=Integer(AAColor.R)+AIntensity;
  AG:=Integer(AAColor.G)+AIntensity;
  AB:=Integer(AAColor.B)+AIntensity;
  //R
  if AR>$FF then begin
    AR-=$FF;
    AVal:=AR div 2;
    AG+=AVal;
    AB+=AVal+(AR and 1); //AB+=AVal+Ord(Odd(AR));
    AR:=$FF;
  end;
  //G
  if AG>$FF then begin
    if AR<$FF then begin
      AG-=$FF;
      AVal:=AG div 2;
      AR+=AVal;
      if AR>$FF then begin
        AVal+=(AR-$FF);
        AR:=$FF;
      end;
      AB+=AVal+(AG and 1); //AB+=AVal+Ord(Odd(AG));
    end else AB+=AG-$FF;
    AG:=$FF;
  end;
  //B
  if AB>$FF then begin
    if AR<$FF then begin
      if AG<$FF then begin
        AB-=$FF;
        AVal:=AB div 2;
        AR+=AVal;
        if AR>$FF then begin
          AVal+=(AR-$FF);
          AR:=$FF;
        end;
        AG+=AVal+(AB and 1); //AG+=AVal+Ord(Odd(AB));
      end else begin
        AR+=(AB-$FF);
        if AR>$FF then AR:=$FF;
      end;
    end else if AG<$FF then begin
      AG+=(AB-$FF);
      if AG>$FF then AG:=$FF;
    end;
    AB:=$FF;
  end;

  AResult.R:=AR;
  AResult.G:=AG;
  AResult.B:=AB;
  AResult.A:=AAColor.A;
end;

function Darken(AColor: TColor32; AIntensity: Byte): TColor32; inline;
var
  AAColor : TARGB absolute AColor;
  AResult : TARGB absolute Result;
  AVal    : Integer;
  AR,AG,AB: Integer;
begin
  AR:=Integer(AAColor.R)-AIntensity;
  AG:=Integer(AAColor.G)-AIntensity;
  AB:=Integer(AAColor.B)-AIntensity;
  //R
  if AR<0 then begin
    AR:=-AR;
    AVal:=AR div 2;
    AG-=AVal;
    AB-=(AVal+(AR and 1)); //AB-=(AVal+Ord(Odd(AR)));
    AR:=0;
  end;
  //G
  if AG<0 then begin
    if AR>0 then begin
      AG:=-AG;
      AVal:=AG div 2;
      AR-=AVal;
      if AR<0 then begin
        AVal-=AR;
        AR:=0;
      end;
      AB-=(AVal+(AG and 1)); //AB-=(AVal+Ord(Odd(AG))=;
    end else AB+=AG;
    AG:=0;
  end;
  //B
  if AB<0 then begin
    if AR>0 then begin
      if AG>0 then begin
        AB:=-AB;
        AVal:=AB div 2;
        AR-=AVal;
        if AR<0 then begin
          AVal-=AR;
          AR:=0;
        end;
        AG-=(AVal+(AB and 1)); //AG-=(AVal+Ord(Odd(AB)));
      end else begin
        AR+=AB;
        if AR<0 then AR:=0;
      end;
    end else if AG>0 then begin
      AG+=AB;
      if AG<0 then AG:=0;
    end;
    AB:=0;
  end;

  AResult.R:=AR;
  AResult.G:=AG;
  AResult.B:=AB;
  AResult.A:=AAColor.A;
end;

function BGRDistance(AColor1,AColor2: TBGR): Integer; inline;
var
  AVal : Integer;
begin
  AVal:=Integer(AColor1.R)-Integer(AColor2.R);
  if AVal>=0 then Result:=AVal else Result:=-AVal;
  AVal:=Integer(AColor1.G)-Integer(AColor2.G);
  if AVal>=0 then Result+=AVal else Result-=AVal;
  AVal:=Integer(AColor1.B)-Integer(AColor2.B);
  if AVal>=0 then Result+=AVal else Result-=AVal;
end;

function ColorDistance(AColor1,AColor2: TColor32): Integer; inline;
var
  ABGR1: TBGR absolute AColor1;
  ABGR2: TBGR absolute AColor2;
begin
  Result:=BGRDistance(ABGR1,ABGR2);
end;

procedure SetRGBColors(var AColors; ACount: Cardinal; AValue: TColor);
var
  ARGBPtr  : PRGB;
  AValue2  : TRGB absolute AValue;
  I        : Integer;
begin
  ARGBPtr:=@AColors;
  for I:=0 to ACount-1 do begin
    ARGBPtr^:=AValue2;
    Inc(ARGBPtr);
  end;
end;

{Operators}

operator = (m1: TBGR; m2: TColor32) r: Boolean;
var
  AColor1: TColor32 absolute m1;
begin
  Result:=((AColor1 and $FFFFFF)=(m2 and $FFFFFF));
end;

operator <> (m1: TBGR; m2: TColor32) r: Boolean;
var
  AColor1: TColor32 absolute m1;
begin
  Result:=((AColor1 and $FFFFFF)<>(m2 and $FFFFFF));
end;

end.

