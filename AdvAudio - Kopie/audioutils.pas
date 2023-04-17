unit AudioUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TComplexFloat=record
    Re,Im: Real;
  end;

(*
  FFT
  Parameter:
  N: Anzahl der Frequenzen, muss eine Zweierpotenz sein
*)
procedure FFT();

implementation

procedure FFT();

begin

end;

end.

