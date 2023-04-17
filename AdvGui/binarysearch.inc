var
  First,Last: Cardinal;
begin
  First:=AMin;
  Last:=AMax;
  Result:=(First+Last) div 2;
  {$DEFINE MIndex := Result}
  while IntAbs(Last-First)>1 do begin
    if MSmaller
      then Last:=Result
      else if MBigger
        then First:=Result
        else {$IFDEF MAutoComplete} begin AValue:=Src[Result]; exit; end; {$ELSE} exit; {$ENDIF}
    Result:=(First+Last) div 2;
  end;

  {$DEFINE MIndex := First}
  if MBigger then begin
    {$DEFINE MIndex := Last}
    if MSmaller
      then Result:=NoResult
      else if MBigger
        then Result:=NoResult
        else Result:=Last;
  {$DEFINE MIndex := First}
  end else if MSmaller
    then Result:=NoResult
    else Result:=First;

  {$IFDEF MAutoComplete}
  AValue:=Src[Result];
  {$ENDIF}

