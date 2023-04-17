unit Fourier;
{$F+,O+}

INTERFACE

{Fensterfunktionen gem„á Studienarbeit Wippermann:}
procedure Dreieck(var W); {W jeweils vom Feldtyp}
procedure Cosinus(var W);
{procedure Expo   (var W);}
procedure Hanning(var W);
procedure Hamming(var W);
procedure Blackman(var W);
procedure Blackman_exakt(var W);
procedure B_Harris_3(var W);
procedure B_Harris_4(var W);
{procedure Tukey  (var W);}
{procedure Poisson(var W);}

{aus Meátechnik gem„á Wetzlar, entspricht Prg. aus Hesselmann:}
PROCEDURE FFT(VAR FR, FI {Feldtyp}; var SIGNUM: shortint);
{Signum: 1 fr FFT, -1 fr IFFT; 0 liefert Fehler zurck !}

IMPLEMENTATION
uses Math; { nur fr's logarithmieren ! }

type Feldtyp=array[0..8192] of real;
var N: word;
    I: integer;
    Korrfak, Wi, A0, A1, A2, A3: real;

procedure Dreieck(var W);
var N0: word absolute W;
begin
  Korrfak:=2.0; N:=N0 shr 1; Feldtyp(W)[1]:=0.0;
  for I:=1 to pred(N) do begin
    Wi:=I/N;
    Feldtyp(W)[succ(I)   ]:=Korrfak*Wi*Feldtyp(W)[succ(I)   ];
    Feldtyp(W)[succ(N0-I)]:=Korrfak*Wi*Feldtyp(W)[succ(N0-I)]
  end;
  Feldtyp(W)[succ(N)]:=Korrfak*Feldtyp(W)[succ(N)]
end;

procedure Cosinus(var W);
var N0: word absolute W;
begin
  Korrfak:=1.5625; N:=N0 shr 1; Feldtyp(W)[1]:=0.0;
  for I:=1 to pred(N) do begin
    Wi:=sin(Pi*I/N0);
    Feldtyp(W)[succ(I)   ]:=Korrfak*Wi*Feldtyp(W)[succ(I)   ];
    Feldtyp(W)[succ(N0-I)]:=Korrfak*Wi*Feldtyp(W)[succ(N0-I)]
  end;
  Feldtyp(W)[succ(N)]:=Korrfak*Feldtyp(W)[succ(N)]
end;

procedure Hanning(var W);
var N0: word absolute W;
begin
  Korrfak:=2.0; N:=N0 shr 1; Feldtyp(W)[1]:=0.0;
  for I:=1 to pred(N) do begin
    Wi:=0.5-0.5*cos(2*Pi*I/N0);
    Feldtyp(W)[succ(I)   ]:=Korrfak*Wi*Feldtyp(W)[succ(I)   ];
    Feldtyp(W)[succ(N0-I)]:=Korrfak*Wi*Feldtyp(W)[succ(N0-I)]
  end;
  Feldtyp(W)[succ(N)]:=Korrfak*Feldtyp(W)[succ(N)]
end;

procedure Hamming(var W);
var N0: word absolute W;
begin
  Korrfak:=1.0/0.54; N:=N0 shr 1; Feldtyp(W)[1]:=Korrfak*0.08*Feldtyp(W)[1];
  for I:=1 to pred(N) do begin
    Wi:=0.54-0.46*cos(2*Pi*I/N0);
    Feldtyp(W)[succ(I)   ]:=Korrfak*Wi*Feldtyp(W)[succ(I)   ];
    Feldtyp(W)[succ(N0-I)]:=Korrfak*Wi*Feldtyp(W)[succ(N0-I)]
  end;
  Feldtyp(W)[succ(N)]:=Korrfak*Feldtyp(W)[succ(N)]
end;

procedure Blackman(var W);
var N0: word absolute W;
begin
  A0:=0.42; A1:=0.5; A2:=0.08;
  Korrfak:=1.0/A0; N:=N0 shr 1; Feldtyp(W)[1]:=0.0;
  for I:=1 to pred(N) do begin
    Wi:=A0-A1*cos(2*Pi*I/N0)+A2*cos(4*Pi*I/N0);
    Feldtyp(W)[succ(I)   ]:=Korrfak*Wi*Feldtyp(W)[succ(I)   ];
    Feldtyp(W)[succ(N0-I)]:=Korrfak*Wi*Feldtyp(W)[succ(N0-I)]
  end;
  Feldtyp(W)[succ(N)]:=Korrfak*Feldtyp(W)[succ(N)]
end;

procedure Blackman_exakt(var W);
var N0: word absolute W;
begin
  A0:=7938.0/18608.0; A1:=9240.0/18608.0; A2:=1430.0/18608.0;
  Korrfak:=1.0/0.46; N:=N0 shr 1;
  Feldtyp(W)[1]:=Korrfak*(A0-A1+A2)*Feldtyp(W)[1];
  for I:=1 to pred(N) do begin
    Wi:=A0-A1*cos(2*Pi*I/N0)+A2*cos(4*Pi*I/N0);
    Feldtyp(W)[succ(I)   ]:=Korrfak*Wi*Feldtyp(W)[succ(I)   ];
    Feldtyp(W)[succ(N0-I)]:=Korrfak*Wi*Feldtyp(W)[succ(N0-I)]
  end;
  Feldtyp(W)[succ(N)]:=Korrfak*Feldtyp(W)[succ(N)]
end;

procedure B_Harris_3(var W);
var N0: word absolute W;
begin
  A0:=0.42323; A1:=0.49755; A2:=0.07922;
  Korrfak:=1.0/A0; N:=N0 shr 1; Feldtyp(W)[1]:=Korrfak*4.9e-3*Feldtyp(W)[1];
  for I:=1 to pred(N) do begin
    Wi:=A0-A1*cos(2*Pi*I/N0)+A2*cos(4*Pi*I/N0);
    Feldtyp(W)[succ(I)   ]:=Korrfak*Wi*Feldtyp(W)[succ(I)   ];
    Feldtyp(W)[succ(N0-I)]:=Korrfak*Wi*Feldtyp(W)[succ(N0-I)]
  end;
  Feldtyp(W)[succ(N)]:=Korrfak*Feldtyp(W)[succ(N)]
end;

procedure B_Harris_4(var W);
var N0: word absolute W;
begin
  A0:=0.35875; A1:=0.48829; A2:=0.14128; A3:=0.01168;
  Korrfak:=1.0/A0; N:=N0 shr 1; Feldtyp(W)[1]:=Korrfak*6e-5*Feldtyp(W)[1];
  for I:=1 to pred(N) do begin
    Wi:=A0-A1*cos(2*Pi*I/N0)+A2*cos(4*Pi*I/N0)-A3*cos(6*Pi*I/N);
    Feldtyp(W)[succ(I)   ]:=Korrfak*Wi*Feldtyp(W)[succ(I)   ];
    Feldtyp(W)[succ(N0-I)]:=Korrfak*Wi*Feldtyp(W)[succ(N0-I)]
  end;
  Feldtyp(W)[succ(N)]:=Korrfak*Feldtyp(W)[succ(N)]
end;

procedure FFT(VAR FR, FI {Feldtyp}; var SIGNUM: shortint);
VAR EL,I,I1,ISTEP,IR,IR1,J,L,M,NN:INTEGER;
    N: word absolute Fr;
    A,WI,WR,TI,TR:REAL;

BEGIN
  A:=ln(n)/0.69314718;
  if (abs(A/round(A)-1)>1e-8) then begin
    Signum:=0; exit
  end;
  IR:=0; NN:=pred(N);
  FOR I:=1 TO NN DO BEGIN
    L:=N; REPEAT L:=L DIV 2 UNTIL (IR+L)<=NN; IR:=L+IR MOD L;
    IF IR>I THEN BEGIN
      I1:=succ(I); IR1:=succ(IR);
      TR:=Feldtyp(Fr)[I1]; Feldtyp(Fr)[I1]:=Feldtyp(Fr)[IR1];
      Feldtyp(Fr)[IR1]:=TR; {Swap von Fr[I1], Fr[Ir1]}
      TI:=Feldtyp(Fi)[I1]; Feldtyp(Fi)[I1]:=Feldtyp(Fi)[IR1];
      Feldtyp(Fi)[IR1]:=TI
    END
  END;
  L:=1;
  WHILE L<N DO BEGIN
    El:=L; L:=L shl 1;
    FOR M:=1 TO El DO BEGIN
      A:=-SIGNUM*PI*pred(M)/EL; WR:=COS(A); WI:=SIN(A);
      I:=M; J:=M+El; WHILE I<=N DO BEGIN
        TR:=WR*Feldtyp(Fr)[J]-WI*Feldtyp(Fi)[J];
        TI:=WR*Feldtyp(Fi)[J]+WI*Feldtyp(Fr)[J];
        Feldtyp(Fr)[J]:=Feldtyp(Fr)[I]-TR; Feldtyp(Fi)[J]:=Feldtyp(Fi)[I]-TI;
        Feldtyp(Fr)[I]:=Feldtyp(Fr)[I]+TR; Feldtyp(Fi)[I]:=Feldtyp(Fi)[I]+TI;
        inc(I,L); inc(J,L)
      END
    END
  END;
  IF SIGNUM=1 THEN FOR I:=1 TO N DO BEGIN
    Feldtyp(Fr)[I]:=Feldtyp(Fr)[I]/N; Feldtyp(Fi)[I]:=Feldtyp(Fi)[I]/N
  END
END;

END.
