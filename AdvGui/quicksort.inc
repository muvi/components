var
  AStackPos,AStackSize,AFirst,ALast,AMiddle,I: Integer;
  APivot,ASwapTmp                            : GElemType;
  AStack                                     : array of TPoint;
begin
  if (AMax-AMin)<1 then exit;
  AStackPos:=AMax-AMin;
  AStackSize:=AStackPos+1;
  SetLength(AStack,AStackSize);
  AStack[AStackPos]:=Point(AMin,AMax);
  while AStackPos<AStackSize do begin
    with AStack[AStackPos] do begin
      AFirst:=X;
      ALast:=Y;
    end;
    Inc(AStackPos);
    APivot:=Src[ALast];
    AMiddle:=AFirst;
    for I:=AFirst to ALast-1 do if MCompare xor ADescending then begin
      //Swap(Src[I],Src[AMiddle]);
      ASwapTmp:=Src[I];
      Src[I]:=Src[AMiddle];
      Src[AMiddle]:=ASwapTmp;

      Inc(AMiddle);
    end;
    //Pivot-Element in die Mitte schieben

    //Swap(Src[ALast],Src[AMiddle]);
    ASwapTmp:=Src[ALast];
    Src[ALast]:=Src[AMiddle];
    Src[AMiddle]:=ASwapTmp;

    //neue Elemente in Stack einfügen
    if (AMiddle-1-AFirst)>0 then begin
      Dec(AStackPos);
      AStack[AStackPos]:=Point(AFirst,AMiddle-1);
    end;
    // ALast-AMiddle-1 =  ALast-(AMiddle+1)
    if (ALast-AMiddle-1)>0 then begin
      Dec(AStackPos);
      AStack[AStackPos]:=Point(AMiddle+1,ALast);
    end;
  end;
  SetLength(AStack,0);

