{TAdvFuncName}

class procedure TAdvFuncName.Swap(var V1,V2: GElemType); inline;
var
  ATemp: GElemType;
begin
  ATemp:=V1;
  V1:=V2;
  V2:=ATemp;
end;

class procedure TAdvFuncName.Quicksort(var Src: GArrayType; ASmaller: TLSmaller; AMax: Integer; AMin: Integer = 0; ADescending: Boolean = false);
  {$DEFINE MCompare := ASmaller(Src[I],APivot)}
  {$I quicksort.inc}
end;

class procedure TAdvFuncName.Quicksort(var Src: GArrayType; ASmaller: TLOSmaller; AMax: Integer; AMin: Integer = 0; ADescending: Boolean = false);
  {$DEFINE MCompare := ASmaller(Src[I],APivot)}
  {$I quicksort.inc}
end;

class function TAdvFuncName.BinarySearch(const AValue: GElemType; constref Src: GArrayType; ASmaller: TLSmaller; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer;
  {$DEFINE MSmaller := ASmaller(AValue,Src[MIndex])}
  {$DEFINE MBigger := ASmaller(Src[MIndex],AValue)}
  {$UNDEF MAutoComplete}
  {$I binarysearch.inc}
end;

class function TAdvFuncName.BinarySearch(const AValue: GElemType; constref Src: GArrayType; ASmaller: TLOSmaller; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer;
  {$DEFINE MSmaller := ASmaller(AValue,Src[MIndex])}
  {$DEFINE MBigger := ASmaller(Src[MIndex],AValue)}
  {$UNDEF MAutoComplete}
  {$I binarysearch.inc}
end;

class function TAdvFuncName.BinarySearchAndComplete(var AValue: GElemType; constref Src: GArrayType; ASmaller: TLSmaller; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer;
  {$DEFINE MSmaller := ASmaller(AValue,Src[MIndex])}
  {$DEFINE MBigger := ASmaller(Src[MIndex],AValue)}
  {$DEFINE MAutoComplete}
  {$I binarysearch.inc}
end;

class function TAdvFuncName.BinarySearchAndComplete(var AValue: GElemType; constref Src: GArrayType; ASmaller: TLOSmaller; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer;
  {$DEFINE MSmaller := ASmaller(AValue,Src[MIndex])}
  {$DEFINE MBigger := ASmaller(Src[MIndex],AValue)}
  {$DEFINE MAutoComplete}
  {$I binarysearch.inc}
end;

{TOperatorFunc}

function TOperatorFuncName.LOSmaller(const V1,V2: GElemType): Boolean;
begin
  Result:=V1<V2;
end;

class function TOperatorFuncName.LSmaller(const V1,V2: GElemType): Boolean;
begin
  Result:=V1<V2;
end;

class procedure TOperatorFuncName.Quicksort(var Src: GArrayType; AMax: Integer; AMin: Integer = 0; ADescending: Boolean = false);
  {$DEFINE MCompare := (Src[I]<APivot)}
  {$I quicksort.inc}
end;

class function TOperatorFuncName.BinarySearch(const AValue: GElemType; constref Src: GArrayType; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer;
  {$DEFINE MSmaller := (AValue<Src[MIndex])}
  {$DEFINE MBigger := (Src[MIndex]<AValue)}
  {$UNDEF MAutoComplete}
  {$I binarysearch.inc}
end;

class function TOperatorFuncName.BinarySearchAndComplete(var AValue: GElemType; constref Src: GArrayType; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer;
  {$DEFINE MSmaller := (AValue<Src[MIndex])}
  {$DEFINE MBigger := (Src[MIndex]<AValue)}
  {$DEFINE MAutoComplete}
  {$I binarysearch.inc}
end;

class procedure TArrayFuncName.DeleteItem(var AArray: GArrayType; AIndex: Integer); inline;
var
  I: Integer;
begin
  for I:=AIndex to Length(AArray)-2
    do AArray[I]:=AArray[I+1];
  SetLength(AArray,Length(AArray)-1);
end;

class procedure TArrayFuncName.InsertInAscending(var AArray: GArrayType; AElem: GElemType); inline;
var
  I,L: Integer;
begin
  L:=Length(AArray);
  SetLength(AArray,L+1);
  I:=L-1;
  while (I>=0) and (AElem<AArray[I]) do begin
    AArray[I+1]:=AArray[I];
    Dec(I);
  end;
  AArray[I+1]:=AElem;
end;

class procedure TArrayFuncName.InsertInDescending(var AArray: GArrayType; AElem: GElemType); inline;
var
  I,L: Integer;
begin
  L:=Length(AArray);
  SetLength(AArray,L+1);
  I:=L-1;
  while (I>=0) and (AArray[I]<AElem) do begin
    AArray[I+1]:=AArray[I];
    Dec(I);
  end;
  AArray[I+1]:=AElem;
end;

class procedure TArrayFuncName.RemoveFromAscending(var AArray: GArrayType; AElem: GElemType); inline;
var
  I         : Integer;
  ATmp,ATmp2: GElemType;
begin
  I:=Length(AArray)-1;
  ATmp:=AArray[I];
  while (I>0) and (AElem<ATmp) do begin
    Dec(I);
    ATmp2:=AArray[I];
    AArray[I]:=ATmp;
    ATmp:=ATmp2;
  end;
  SetLength(AArray,Length(AArray)-1);
end;

class procedure TArrayFuncName.RemoveFromDescending(var AArray: GArrayType; AElem: GElemType); inline;
var
  I         : Integer;
  ATmp,ATmp2: GElemType;
begin
  I:=Length(AArray)-1;
  ATmp:=AArray[I];
  while (I>0) and (ATmp<AElem) do begin
    Dec(I);
    ATmp2:=AArray[I];
    AArray[I]:=ATmp;
    ATmp:=ATmp2;
  end;
  SetLength(AArray,Length(AArray)-1);
end;

