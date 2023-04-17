type
  generic TAdvFuncName<GArrayType,GElemType> = class
  public
    type
      TLSmaller = function (const V1,V2: GElemType): Boolean;
      TLOSmaller= function (const V1,V2: GElemType): Boolean of object;
    class procedure Swap(var V1,V2: GElemType); inline;
    class procedure Quicksort(var Src: GArrayType; ASmaller: TLSmaller; AMax: Integer; AMin: Integer = 0; ADescending: Boolean = false); overload;
    class procedure Quicksort(var Src: GArrayType; ASmaller: TLOSmaller; AMax: Integer; AMin: Integer = 0; ADescending: Boolean = false); overload;
    //BinarySearch: für Suche in absteigend sortiertem Feld AMax und AMin vertauschen
    class function BinarySearch(const AValue: GElemType; constref Src: GArrayType; ASmaller: TLSmaller; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer; overload;
    class function BinarySearch(const AValue: GElemType; constref Src: GArrayType; ASmaller: TLOSmaller; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer; overload;
    class function BinarySearchAndComplete(var AValue: GElemType; constref Src: GArrayType; ASmaller: TLSmaller; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer; overload;
    class function BinarySearchAndComplete(var AValue: GElemType; constref Src: GArrayType; ASmaller: TLOSmaller; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer; overload;
  end;

  generic TOperatorFuncName<GArrayType,GElemType> = class (specialize TAdvFuncName<GArrayType,GElemType>)
  public
    function LOSmaller(const V1,V2: GElemType): Boolean;
    class function LSmaller(const V1,V2: GElemType): Boolean;
    class procedure Quicksort(var Src: GArrayType; AMax: Integer; AMin: Integer = 0; ADescending: Boolean = false); overload;
    class function BinarySearch(const AValue: GElemType; constref Src: GArrayType; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer; overload;
    class function BinarySearchAndComplete(var AValue: GElemType; constref Src: GArrayType; AMax: Integer; AMin: Integer = 0; NoResult: Integer = -1): Integer; overload;
  end;

  generic TArrayFuncName<GElemType> = class
  public
    type
      GArrayType  = array of GElemType;
    class procedure DeleteItem(var AArray: GArrayType; AIndex: Integer); inline;
    class procedure InsertInAscending(var AArray: GArrayType; AElem: GElemType); inline;
    class procedure InsertInDescending(var AArray: GArrayType; AElem: GElemType); inline;
    class procedure RemoveFromAscending(var AArray: GArrayType; AElem: GElemType); inline;
    class procedure RemoveFromDescending(var AArray: GArrayType; AElem: GElemType); inline;
  end;

