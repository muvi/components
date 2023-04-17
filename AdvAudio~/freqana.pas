unit FreqAna;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, SpectrumData;

type
  {TWaveAnalyser       = class

  end;}

  //TASIWData           = array of Single;
  //PASIWData           = ^TASIWData;

  TADBuf              = array of Single;


  {TSD2WData           = array of TADBuf;
  PSD2WData           = ^TSD2WData;}
  TSD2WData           = type Pointer;

  TGetLevels          = function (const Index,Channel: MVInt): MVFloat of object;
  TGetLevelsC         = function (const Index: MVInt): MVFloat of object;

  TSpectrumData2      = class ({TInterfaced}TObject, ISpectrumData)
  {strict} private
    //FBuffer       : Pointer;                 TInterfacedObject
    //FBytes        : Cardinal;
    FWDatas       : {array of }TSD2WData;
    FLevels       : TSD2WData;
    FReBuf        : TSD2WData;
    FImBuf        : TSD2WData;
    FPeak         : TSD2WData;
    //FSampleSize   : Cardinal;
    //FSampleBufSize: Cardinal;
    //FBytesToRead  : Cardinal;
    FChannels     : MVInt;
    FFreqCount    : MVInt;
    FSampleCount  : MVInt;
    FBufferCount  : MVInt;
    FSampleRate   : MVInt;
    //FInterval     : Cardinal;
    //FOnReady      : TFFTThreadEvent;
    //FGetPeak      : TFFTThreadEvent;
    FFFTMode      : TFFTMode;
    FAnalyseMode  : TSDAnalyseMode;

    //intern
    fftA          : Real;

    FABuffer      : Cardinal;
    FChannelSize  : Cardinal;
    FBufSize      : Cardinal;
    FBufsSize     : Cardinal;
    FFChannelSize : Cardinal;
    FFBufSize     : Cardinal;

    FDoGetLevels  : TGetLevels;
    FDoGetLevelsC : TGetLevelsC;

    function FFTInit: Boolean; inline;
    procedure FFT(var AFR,AFI; const Signum: ShortInt = 1); inline;

    procedure DoFFT; inline;
    procedure DoGetPeak; inline;

    procedure SetBufferCount(Value: Cardinal);
    procedure SetChannels(Value: Cardinal);
    procedure SetFreqCount(Value: Cardinal);
    procedure SetSampleCount(Value: Cardinal);
    procedure SetSampleRate(Value: Cardinal);

    function GetLevels_Combined_First(const Index,Channel: MVInt): MVFloat;
    function GetLevels_AllChannels(const Index,Channel: MVInt): MVFloat;
    function GetLevelsC_Combined_First(const Index: MVInt): MVFloat;
    function GetLevelsC_AllChannels(const Index: MVInt): MVFloat;

    {procedure FFT_Combined;
    procedure FFT_AllChannels;
    procedure FFT_First;}
    function GetFFTMode: TFFTMode; stdcall;
    function GetAnalyseMode: TSDAnalyseMode; stdcall;
    procedure SetFFTMode(Value: TFFTMode); stdcall;
    procedure SetAnalyseMode(Value: TSDAnalyseMode); stdcall;
  public
    FWData        : TSD2WData;
  private
    function GetChannels: MVInt; stdcall;
    function GetBufferCount: MVInt; stdcall;
    function GetFreqCount: MVInt; stdcall;
    function GetLongWaveDataCount: MVInt; stdcall;
    function GetSampleCount: MVInt; stdcall;
    function GetSampleRate: MVInt; stdcall;

    function GetLevels(const Index,Channel: MVInt): MVFloat; stdcall;
    function GetLevelsC(const Index: MVInt): MVFloat; stdcall;
    function GetWaveData(const Index,Channel: MVInt): MVFloat; stdcall;
    function GetWaveDataC(const Index: MVInt): MVFloat; stdcall;
    function GetWaveDataLong(const Index,Channel: MVInt): MVFloat; stdcall;
    function GetWaveDataLongB(const Index,Channel,Buffer: MVInt): MVFloat; stdcall;
    function GetWaveDataLongC(const Index: MVInt): MVFloat; stdcall;
    function GetWaveDataLongBC(const Index,Buffer: MVInt): MVFloat; stdcall;
    function GetPeak(const Channel: MVInt): MVFloat; stdcall;
  protected
    function QueryInterface(const iid : tguid;out obj) : longint;stdcall;
    function _AddRef : longint;stdcall;
    function _Release : longint;stdcall;
    (*function GetLevels(Index : Cardinal) : Real; override;
    function GetWaveData(Index,Channel: Cardinal): Real; overload; override;
    function GetWaveData(Index: Cardinal): Real; overload; override;
    function GetWaveDataLong(Index,Channel,Buffer: Cardinal): Real;  overload; override;
    function GetWaveDataLong(Index,Channel: Cardinal): Real; overload; override;
    function GetWaveDataLongC(Index,Buffer: Cardinal): Real; overload; override;
    function GetWaveDataLongC(Index: Cardinal): Real; overload; override;
    function GetLongWaveDataCount: Cardinal; override;
    function GetPeak(Channel: Cardinal): Real; overload; override;
    function GetFreqCount: Cardinal; override;
    function GetBufferCount: Integer; override;
    function GetChannels: Cardinal; override;*)
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SetCounts(const AChannels,ASampleCount,AFreqCount,ABufferCount: Cardinal);
    procedure Analyse;
    //function DstBuf:
    //procedure Analyse(var Buffer: Pointer);
    (*constructor Create{(ASpectrumIndicator: TAdvancedSpectrumIndicator)};
    procedure SetBufferInfo;
    procedure Analyse(var Buffer: Pointer);
    //procedure AssignSpectrumIndicator(ASpectrumIndicator: TAdvancedSpectrumIndicator);
    property Channels: Cardinal;
    property FreqCount: Cardinal read GetFreqCount;
    property BufferCount: Integer read GetBufferCount;
    property LongWaveDataCount: Cardinal read GetLongWaveDataCount;
    property Levels[Index : Cardinal]: Real read GetLevels;
    property WaveData[Index,Channel: Cardinal]: Real read GetWaveData;
    property WaveData[Index: Cardinal]: Real read GetWaveData;
    property WaveDataLong[Index,Channel,Buffer: Cardinal]: Real read GetWaveDataLong;
    property WaveDataLong[Index,Channel: Cardinal]: Real read GetWaveDataLong;
    property WaveDataLongC[Index,Buffer: Cardinal]: Real read GetWaveDataLongC;
    property WaveDataLongC[Index: Cardinal]: Real read GetWaveDataLongC;
    property Peak[Channel: Cardinal]: Real read GetPeak;  *)
  published
    property Channels: MVInt read FChannels write SetChannels;
    property BufferCount: MVInt read FBufferCount write SetBufferCount;
    property FreqCount: MVInt read FFreqCount write SetFreqCount;
    property LongWaveDataCount: MVInt read GetLongWaveDataCount;
    property SampleCount: MVInt read FSampleCount write SetSampleCount;
    property SampleRate: MVInt read FSampleRate write SetSampleRate;
  end;

type
  TSD2BufferFormat = array [0..0] of MVFloat;
  PSD2BufferFormat = ^TSD2BufferFormat;
  TSD2BufElem      = MVFloat;
  PSD2BufElem      = ^TSD2BufElem;

implementation


const
  ln2           = 0.69314718;
  SD2BufElemSize= SizeOf(TSD2BufElem);
  {
  MGetLevels : array [TFFTMode] of TGetLevels  = (@GetLevels_Combined_First,@GetLevels_AllChannels,@GetLevels_Combined_First);
  MGetLevelsC: array [TFFTMode] of TGetLevelsC = (@GetLevelsC_Combined_First,@GetLevelsC_AllChannels,@GetLevelsC_Combined_First);
  }

constructor TSpectrumData2.Create;
begin
  inherited Create;
  FChannelSize:=0;
  FBufSize:=0;
  FBufsSize:=0;
  FFFTMode:=fftFirst;
  FAnalyseMode:=[afFFT,afPeak];
  FDoGetLevels:=@GetLevels_Combined_First;
  FDoGetLevelsC:=@GetLevelsC_Combined_First;
  FFreqCount:=0;
end;

destructor TSpectrumData2.Destroy;
begin
  (***)
  inherited Destroy;
  //Self._Release;
  //inherited Destroy;
end;

function TSpectrumData2.QueryInterface(const iid : tguid;out obj) : longint;stdcall;
begin
  Result:=0;
end;

function TSpectrumData2._AddRef : longint;stdcall;
begin

end;

function TSpectrumData2._Release : longint;stdcall;
begin

end;

procedure TSpectrumData2.Analyse;
var
  I             : Integer;
  APrecisionMode: TFPUPrecisionMode;
begin
  APrecisionMode:=GetPrecisionMode;
  SetPrecisionMode(pmSingle);
  //FFT(FReBuf,FImBuf,FFreqCount,Sign);
  DoFFT;
  DoGetPeak;

  FABuffer:=succ(FABuffer) mod FBufferCount;
  FWData:=FWDatas+(FABuffer*FBufSize);
  //for I:=0 to FFreqCount-1 do FLevels[I]:=Sqrt(Sqr(FReBuf[I])+Sqr(FImBuf[I]));
  SetPrecisionMode(APrecisionMode);
end;

procedure TSpectrumData2.DoFFT;
var
  I,J,IJ : Integer;
  AReBuf : PSD2BufferFormat absolute FReBuf;
  AImBuf : PSD2BufferFormat absolute FImBuf;
  AWData : PSD2BufferFormat absolute FWData;
  ALevels: PSD2BufferFormat absolute FLevels;
begin
  IJ:=0;
  for I:=0 to FFreqCount-1 do begin
    AReBuf^[I]:=0.0;
    for J:=0 to FChannels-1 do begin
      AReBuf^[I]+=AWData^[IJ];
      Inc(IJ);
    end;
    AReBuf^[I]/=FChannels;
    AImBuf^[I]:=0.0;
  end;

  FFT(FReBuf^,FImBuf^);

  for I:=0 to FFreqCount-1 do ALevels^[I]:=Sqrt(Sqr(AReBuf^[I])+Sqr(AImBuf^[I]));
end;

procedure TSpectrumData2.DoGetPeak;
var
  I,J   : Integer;
  APeak : ^MVFloat;
  AWData: ^MVFloat;
begin
  APeak:=FPeak;
  AWData:=FWData;
  for I:=0 to FChannels-1 do begin
    APeak^:=0;
    for J:=0 to FSampleCount-1 do begin
      APeak^+=Abs(AWData^);
      AWData+=SD2BufElemSize;
    end;
    APeak^/=FSampleCount;
    APeak+=SD2BufElemSize;
  end;
end;

function TSpectrumData2.FFTInit: Boolean;
begin
  fftA:=ln(FFreqCount)/ln2;
  Result:=(abs(fftA/round(fftA)-1)>1e-8);
end;

procedure TSpectrumData2.FFT(var AFR, AFI; const Signum: ShortInt = 1);
var
  EL,I,I1,ISTEP,IR,IR1,J,L,M,NN: Integer;
    //N: word absolute Fr;
    {A,}WI,WR,TI,TR            : Real;
  FR: TSD2BufferFormat absolute AFR;
  FI: TSD2BufferFormat absolute AFI;
begin
  {A:=ln(n)/0.69314718;
  if (abs(A/round(A)-1)>1e-8) then begin
    Signum:=0; exit
  end;}
  IR:=-1; NN:=pred(FFreqCount);
  for I:=0 to pred(NN) do begin
    L:=FFreqCount;
    repeat
      L:=L div 2
    until (IR+1+L)<=NN;
    IR:=(L+(IR+1) mod L)-1;
    if IR+1>I+1 then begin
      I1:=succ(I+1);
      IR1:=succ(IR+1);

      TR:=Fr[I1];
      Fr[I1]:=Fr[IR1];
      Fr[IR1]:=TR; {Swap von Fr[I1], Fr[Ir1]}

      TI:=Fi[I1];
      Fi[I1]:=Fi[IR1];
      Fi[IR1]:=TI
    end;
  end;
  L:=1;
  while L<FFreqCount do begin
    El:=L;
    L:=L shl 1;
    for M:=0 to pred(El) do begin
      fftA:=-SIGNUM*PI*M/succ(EL); WR:=COS(fftA); WI:=sin(fftA);
      I:=M;
      J:=M+El;
      while I<FFreqCount do begin
        TR:=WR*Fr[J]-WI*Fi[J];
        TI:=WR*Fi[J]+WI*Fr[J];
        Fr[J]:=Fr[I]-TR; Fi[J]:=Fi[I]-TI;
        Fr[I]:=Fr[I]+TR; Fi[I]:=Fi[I]+TI;
        inc(I,L); inc(J,L)
      end;
    end;
  end;
  if SIGNUM=1 then for I:=0 to pred(FFreqCount) do begin
    Fr[I]:=Fr[I]/FFreqCount;
    Fi[I]:=Fi[I]/FFreqCount;
  end;
end;


procedure TSpectrumData2.SetCounts(const AChannels,ASampleCount,AFreqCount,ABufferCount: Cardinal);
begin
  FreeMem(FWDatas,FBufsSize);
  FreeMem(FLevels,FFBufSize);
  FreeMem(FReBuf,FFBufSize);
  FreeMem(FImBuf,FFBufSize);
  FreeMem(FPeak,FChannels*SD2BufElemSize);

  FABuffer:=0;

  FChannelSize:=ASampleCount*SD2BufElemSize;
  FBufSize:=FChannelSize*AChannels;
  FBufsSize:=FBufSize*ABufferCount;
  FFChannelSize:=AFreqCount*SD2BufElemSize;
  case FFFTMode of
    fftCombined   : FFBufSize:=FFChannelSize;
    fftAllChannels: FFBufSize:=FFChannelSize*AChannels;
    fftFirst      : FFBufSize:=FFChannelSize;
  end;

  FChannels:=AChannels;
  FSampleCount:=ASampleCount;
  FFreqCount:=AFreqCount;
  FBufferCount:=ABufferCount;

  GetMem(FWDatas,FBufsSize);
  GetMem(FLevels,FFBufSize);
  GetMem(FReBuf,FFBufSize);
  GetMem(FImBuf,FFBufSize);
  GetMem(FPeak,FChannels*SD2BufElemSize);


  FFTInit;
  FWData:=FWDatas;
end;

procedure TSpectrumData2.SetBufferCount(Value: Cardinal);
begin
  FreeMem(FWDatas,FBufsSize);
  FBufferCount:=Value;
  FBufsSize:=FBufSize*Value;
  GetMem(FWDatas,FBufsSize);
  FABuffer:=0;
  FWData:=FWDatas;
end;

procedure TSpectrumData2.SetChannels(Value: Cardinal);
begin
  SetCounts(Value,FSampleCount,FFreqCount,FBufferCount);
end;

procedure TSpectrumData2.SetFreqCount(Value: Cardinal);
begin
  FreeMem(FLevels,FFBufSize);
  FreeMem(FREBuf,FFBufSize);
  FreeMem(FImBuf,FFBufSize);
  FFChannelSize:=Value*SD2BufElemSize;
  case FFFTMode of
    fftCombined   : FFBufSize:=FFChannelSize;
    fftAllChannels: FFBufSize:=FFChannelSize*FChannels;
    fftFirst      : FFBufSize:=FFChannelSize;
  end;
  GetMem(FLevels,FFBufSize);
  GetMem(FREBuf,FFBufSize);
  GetMem(FImBuf,FFBufSize);
  FFTInit;
  FFreqCount:=Value;
end;

procedure TSpectrumData2.SetSampleCount(Value: Cardinal);
begin
  FreeMem(FWDatas,FBufsSize);

  FChannelSize:=Value*SD2BufElemSize;
  FBufSize:=FChannelSize*FChannels;
  FBufsSize:=FBufSize*FBufferCount;

  GetMem(FWDatas,FBufsSize);

  FSampleCount:=Value;
  FABuffer:=0;
  FWData:=FWDatas;
end;

procedure TSpectrumData2.SetSampleRate(Value: Cardinal);
begin
  FSampleRate:=Value;
end;

procedure TSpectrumData2.SetFFTMode(Value: TFFTMode); stdcall;
begin
  case Value of
    fftCombined,fftFirst: begin
        FDoGetLevels:=@GetLevels_Combined_First;
        FDoGetLevelsC:=@GetLevelsC_Combined_First;
      end;
    fftAllChannels      : begin
        FDoGetLevels:=@GetLevels_AllChannels;
        FDoGetLevelsC:=@GetLevelsC_AllChannels;
      end;
  end;
  FFFTMode:=Value;
end;

procedure TSpectrumData2.SetAnalyseMode(Value: TSDAnalyseMode); stdcall;
begin
  FAnalyseMode:=Value;
end;


function TSpectrumData2.GetChannels: MVInt; stdcall;
begin
  Result:=FChannels;
end;

function TSpectrumData2.GetBufferCount: MVInt; stdcall;
begin
  Result:=FBufferCount;
end;

function TSpectrumData2.GetFreqCount: MVInt; stdcall;
begin
  Result:=FFreqCount;
end;

function TSpectrumData2.GetLongWaveDataCount: MVInt; stdcall;
begin
  Result:=FSampleCount*FBufferCount;
end;

function TSpectrumData2.GetSampleCount: MVInt; stdcall;
begin
  Result:=FSampleCount;
end;

function TSpectrumData2.GetSampleRate: MVInt; stdcall;
begin
  Result:=FSampleRate;
end;

function TSpectrumData2.GetFFTMode: TFFTMode; stdcall;
begin
  Result:=FFFTMode;
end;

function TSpectrumData2.GetAnalyseMode: TSDAnalyseMode; stdcall;
begin
  Result:=FAnalyseMode;
end;


function TSpectrumData2.GetLevels_Combined_First(const Index,Channel: MVInt): MVFloat;
var
  ABuf: PSD2BufferFormat absolute FLevels;
begin
  Result:=ABuf^[Index];
end;

function TSpectrumData2.GetLevels_AllChannels(const Index,Channel: MVInt): MVFloat;
var
  ABuf: PSD2BufferFormat absolute FLevels;
begin
  Result:=ABuf^[(Channel*FFreqCount)+Index];
end;

function TSpectrumData2.GetLevelsC_Combined_First(const Index: MVInt): MVFloat;
var
  ABuf: PSD2BufferFormat absolute FLevels;
begin
  Result:=ABuf^[Index];
end;

function TSpectrumData2.GetLevelsC_AllChannels(const Index: MVInt): MVFloat;

  procedure _Do_(var buf);
  var
    ABuf: TSD2BufElem absolute buf;
  begin
    Result+=ABuf;
  end;

var
  I      : Integer;
  ABufPos: TSD2WData;
begin
  Result:=0;
  ABufPos:=FLevels+(Index*SD2BufElemSize);
  for I:=0 to FChannels-1 do begin
    _Do_(ABufPos);
    ABufPos+=FFChannelSize;
  end;
  Result/=FChannels;
end;


function TSpectrumData2.GetLevels(const Index,Channel: MVInt): MVFloat; stdcall;
begin
  Result:=FDoGetLevels(Index,Channel);
  //Meldung('es klappt',TdmInfo);
end;

function TSpectrumData2.GetLevelsC(const Index: MVInt): MVFloat; stdcall;
var
  I: Integer;
begin
  Result:=FDoGetLevelsC(Index);
{  Result:=0;
  for I:=0 to FChannels-1 do Result+=FLevels[I][Index];
  Result/=FChannels;}
end;

function TSpectrumData2.GetWaveData(const Index,Channel: MVInt): MVFloat; stdcall;
var
  ABuf: PSD2BufferFormat absolute FWData;
begin
  Result:=ABuf^[(Channel*FSampleCount)+Index];
end;

function TSpectrumData2.GetWaveDataC(const Index: MVInt): MVFloat; stdcall;

  procedure _Do_(var buf);
  var
    ABuf: TSD2BufElem absolute buf;
  begin
    Result+=ABuf;
  end;

var
  I     : Integer;
  BufPos: TSD2WData;
begin
  Result:=0;
  BufPos:=FWData+(Index*SD2BufElemSize);
  for I:=0 to FChannels-1 do begin
    _Do_(BufPos^);
    BufPos+=FChannelSize;
  end;
  Result/=FChannels;
end;

function TSpectrumData2.GetWaveDataLong(const Index,Channel: MVInt): MVFloat; stdcall;
var
  ABuf: PSD2BufferFormat absolute FWDatas;
begin
  Result:=ABuf^[((Index div FSampleCount)*FBufSize)+(Channel*FChannelSize)+(Index mod FSampleCount)];
end;

function TSpectrumData2.GetWaveDataLongB(const Index,Channel,Buffer: MVInt): MVFloat; stdcall;
var
  ABuf: PSD2BufferFormat absolute FWDatas;
begin
  Result:=ABuf^[(Buffer*FBufSize)+(Channel*FChannelSize)+Index];
end;

function TSpectrumData2.GetWaveDataLongC(const Index: MVInt): MVFloat; stdcall;
begin
  Result:=GetWaveDataLongBC(Index mod FSampleCount,Index div FSampleCount);
end;

function TSpectrumData2.GetWaveDataLongBC(const Index,Buffer: MVInt): MVFloat; stdcall;

  procedure _Do_(var buf);
  var
    ABuf: TSD2BufElem absolute buf;
  begin
    Result+=ABuf;
  end;

var
  I     : Integer;
  BufPos: TSD2WData;
begin
  Result:=0;
  BufPos:=FWData+(Buffer*FBufSize)+(Index*SD2BufElemSize);
  for I:=0 to FChannels-1 do begin
    _Do_(BufPos^);
    BufPos+=FChannelSize;
  end;
  Result/=FChannels;
end;

function TSpectrumData2.GetPeak(const Channel: MVInt): MVFloat; stdcall;
var
  ABuf: PSD2BufferFormat absolute FPeak;
begin
  Result:=ABuf^[Channel];
end;


end.

