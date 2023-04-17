unit FreqAna;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, SpectrumData, Dialogs, UltraSort;

type
  {TWaveAnalyser       = class

  end;}

  //TASIWData           = array of Single;
  //PASIWData           = ^TASIWData;

  TADBuf              = array of Single;


  {TSD2WData           = array of TADBuf;
  PSD2WData           = ^TSD2WData;}
  TSD2WData           = type Pointer;
  TSD2IntData         = type Pointer;
  TSD2Bits            = type Pointer;

  TGetLevels          = function (const Index,Channel: MVInt): MVFloat of object;
  TGetLevelsC         = function (const Index: MVInt): MVFloat of object;
  TBeatControlState   = (bsFound,bsWaiting);
  MVSInt              = LongInt;
  MVTime              = UInt64;

  {TBufferedBeat       = packed record
    Bass,BassVocal,TrebleVocal,Treble,Peak: MVFloat;
  end;

  TBeatCount          = packed record
    Bass,BassVocal,TrebleVocal,Treble,Peak: MVTime;
  end;

  TIntBeat            = packed record
    Bass,BassVocal,TrebleVocal,Treble,Peak: MVInt;
  end; }

  TBeatTag            = (btPeak = 0,btBass = 1,btBassVocal = 2,btTrebleVocal = 3,btTreble = 4);
  TBeatTags           = set of TBeatTag;

  TBeatState          = record
    Beat,SubBeat,Max,Expected,Ticks: MVInt;
    State                          : TBeatControlState;
    //Wait                           : MVSInt;
    Togg,Free,PreFree              : TBeatTags;
    //LastBeat                       : TBufferedBeat;
    Tags                           : TBeatTags;
    //Sink                           : TBufferedBeat;
    //LastBeat                       : TBeatCount;
    //LastBeat2                      : TBeatCount;
    //BeatTime                       : TBeatCount;
    BeatStart                      : MVTime{TBeatCount};
  end;

  TFSBeatBuffers      = record
    SSubbandHistory,SAverageSoundEnergys,SBeatEquality                                                                                                         : TSD2WData;
    SBeatAtHistory,SIsBeatAt,SBeatAtHistory2,SIsBeatAt2                                                                                                        : TSD2Bits;
    SBeatAtSize,SBeatAtCount,SSHSize,SSubbandSize,SBeatHistoryCount,SBeatAtPos,SBeatAtPos2,SBeatHistorySize,SBeatCompareCount,SBeatEqualityCount,SBPMContinuity: MVInt;
    SBandWidths                                                                                                                                                : TSD2IntData;
    SAverageBeatEquality,SLastBPM                                                                                                                              : MVFloat;
  end;

  TBPMFoundMode       = (bpmFalse = 0, bpmTrue = 1, bpmScanning = 2);

  TSpectrumData2      = class;

  TBPMThread          = class (TThread)
  private
    FSpectrumData: TSpectrumData2;
    FFramesNeeded: MVInt;
    FFramesUsed  : MVInt;
    FReady       : Boolean;
  protected
    FBPMList           : TUltraSortList;
    FBPMHistoryList    : TUltraSortList;
    procedure Execute; override;
  public
    constructor Create(AOwner: TSpectrumData2); virtual;
    destructor Destroy; override;
    procedure NextFrame;
    property FramesNeeded: MVInt read FFramesNeeded;
  end;

  TSpectrumData2      = class ({TInterfaced}TObject, ISpectrumData)
  {strict} private
    //FBuffer       : Pointer;                 TInterfacedObject
    //FBytes        : Cardinal;
    FWDatas            : {array of }TSD2WData;
    FLevels            : TSD2WData;
    FReBuf             : TSD2WData;
    FImBuf             : TSD2WData;
    FPeak              : TSD2WData;
    FLPeak             : TSD2WData;
    FNormLevel         : MVFloat;
    FNormBass          : MVFloat;
    //FSampleSize   : Cardinal;
    //FSampleBufSize: Cardinal;
    //FBytesToRead  : Cardinal;
    FChannels          : MVInt;
    FFreqCount         : MVInt;
    FWaveDataCount     : MVInt;
    FBufferCount       : MVInt;
    FSampleRate        : MVInt;
    FLPeakCount        : MVInt;

    //FBeatTickStart: UInt64;
    //FExpTickStart : UInt64;
    //FNormBeatTicks: Cardinal;
    //FLastBeatTicks: UInt64;
    FBeat              : TBeatState;
    FBeatSensibility   : MVFloat;
    //FInterval     : Cardinal;
    //FOnReady      : TFFTThreadEvent;
    //FGetPeak      : TFFTThreadEvent;
    FFFTMode           : TFFTMode;
    FAnalyseMode       : TSDAnalyseMode;

    FSoundHistory      : TSD2WData;
    FMainBeatBuffer    : TSD2WData;
    //FBeatBuffers       : TSD2WData;
    FBeatBandHistory   : TSD2WData;
    FBPMHistory        : TSD2WData;

    FBeatOnBand        : Pointer;

    FSoundEnergyAverage: MVFloat;

    //FBeatIterCount     : MVInt;
    //FBeatBufferCount  : MVInt;

    //FBeatBuffer        : TSD2WData;
    //FBeatBuffer2       : TSD2WData;
    //FBeatBuffer3       : TSD2WData;
    //FBeatBuffer4       : TSD2WData;
    //FBB3Pos            : TIntBeat;
    //FBB4Pos            : TIntBeat;
    //FBeatDirection     : Byte;
    //FNormBeatVal       : TBufferedBeat;
    FNormBeatDiff      : MVFloat{TBufferedBeat};
    //FPreBeatDiff       : TBufferedBeat;
    //FBeatDiff2         : TBufferedBeat;
    FBeatBufCount      : Cardinal;
    //FBB4Count          : Cardinal;
    FABeatBuf          : Cardinal;
    FBeatSubbandCount  : MVInt;
    FBeatSubbandBufSize: Cardinal;
    FFSSensibility     : MVFloat;
    FBPMSensibility    : MVFloat;
    FBPM               : MVFLoat;
    FBPMFound          : TBPMFoundMode;
    FBPMHistoryCount   : MVInt;
    FBPMHistoryPos     : MVInt;

    FFSBeatBuffers     : TFSBeatBuffers;

    FTickCount         : MVTime;

    //intern
    fftA               : Real;

    {FSBBSize           : Cardinal;
    FBBSize            : Cardinal;
    FBBSSize           : Cardinal;}

    FABuffer           : Cardinal;
    FChannelSize       : Cardinal;
    FBufSize           : Cardinal;
    FBufsSize          : Cardinal;
    FFChannelSize      : Cardinal;
    FFBufSize          : Cardinal;

    FDoGetLevels       : TGetLevels;
    FDoGetLevelsC      : TGetLevelsC;

    FBPMThread         : TBPMThread;
    //FBPMList           : TUltraSortList;
    //FBPMHistoryList    : TUltraSortList;

    FBeatOptimizer     : Boolean;

    function FFTInit: Boolean; inline;
    procedure FFT(var AFR,AFI; const Signum: ShortInt = 1); inline;

    procedure DoFFT; inline;
    procedure DoGetPeak; inline;
    procedure DoGetBeat; inline;
    procedure DoGetBeatFS; inline;
    //procedure DoGetBeatOld0; inline;
    //procedure DoGetBeatOld; inline;
    //procedure DoGetRythm; inline;
    procedure DoGetBPM; {inline;}

    procedure SetBufferCount(Value: MVInt);
    procedure SetChannels(Value: MVInt);
    procedure SetFreqCount(Value: MVInt);
    procedure SetWaveDataCount(Value: MVInt);
    procedure SetSampleRate(Value: MVInt);
    //procedure SetLPeakCount(Value: MVInt);

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
    procedure Tick; inline;
  private
    function GetChannels: MVInt; stdcall;
    function GetBufferCount: MVInt; stdcall;
    function GetFreqCount: MVInt; stdcall;
    function GetLongWaveDataCount: MVInt; stdcall;
    function GetWaveDataCount: MVInt; stdcall;
    function GetLPeakCount: MVInt; stdcall;
    function GetSampleRate: MVInt; stdcall;
    function GetBeatBufCount: MVInt; stdcall;

    function GetBPMAnalysisTime: MVInt; stdcall;

    function GetLevels(const Index,Channel: MVInt): MVFloat; stdcall;
    function GetLevelsC(const Index: MVInt): MVFloat; stdcall;
    function GetWaveData(const Index,Channel: MVInt): MVFloat; stdcall;
    function GetWaveDataC(const Index: MVInt): MVFloat; stdcall;
    function GetWaveDataLong(const Index,Channel: MVInt): MVFloat; stdcall;
    function GetWaveDataLongB(const Index,Channel,Buffer: MVInt): MVFloat; stdcall;
    function GetWaveDataLongC(const Index: MVInt): MVFloat; stdcall;
    function GetWaveDataLongBC(const Index,Buffer: MVInt): MVFloat; stdcall;
    function GetPeak(const Channel: MVInt): MVFloat; stdcall;
    {function GetBeatBuf(const Index: MVInt): TBufferedBeat; stdcall;
    function GetBeatBuf2(const Index: MVInt): TBufferedBeat; stdcall;
    function GetBeatBuf3(const Index: MVInt): TBufferedBeat; stdcall;
    function GetBeatBuf4(const Index: MVInt): TBufferedBeat; stdcall; }

    function GetSoundHistory(const Index: MVInt): MVFloat{TBufferedBeat}; stdcall;
    function GetMainBeatBuffer(const Index: MVInt): MVFloat{TBufferedBeat}; stdcall;
    //function GetBeatBufferX(const Buffer,Index: MVInt): TBufferedBeat; stdcall;

    function GetBeatAt(const Subband,History: MVInt): Boolean; stdcall;
    function GetFSAverage(const Subband: MVInt): MVFloat; stdcall;
    function GetFSHistory(const Index,Subband: MVInt): MVFloat; stdcall;

    function GetBeatHistoryCount: MVInt;
    function GetBeatEqualityCount: MVInt;
    function GetBeatEquality(const History: MVInt): MVFloat;
    function GetAverageBeatEquality: MVFloat;

    procedure CalcBandWidths;
    function InstantSoundEnergy: MVFloat;
    function SoundEnergyVariance(const ANewEnergy: MVFloat): MVFloat;
  protected
    function QueryInterface(const iid : tguid; out obj) : longint; stdcall;
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
    procedure SetCounts(const AChannels,AWaveDataCount,AFreqCount,ABufferCount,ABeatBufCount,ABB4Count,ABeatIterCount,ABeatSubbandCount,ABeatHistoryCount,ABeatCompareCount,ABPMHistoryCount: Cardinal);
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
    property Beat: TBeatState read FBeat;
    {property BeatBuffer[Index: MVInt]: TBufferedBeat read GetBeatBuf;
    property BeatBuffer2[Index: MVInt]: TBufferedBeat read GetBeatBuf2;
    property BeatBuffer3[Index: MVInt]: TBufferedBeat read GetBeatBuf3;
    property BeatBuffer4[Index: MVInt]: TBufferedBeat read GetBeatBuf4;}
    property SoundHistory[Index: MVInt]: MVFloat{TBufferedBeat} read GetSoundHistory;
    property MainBeatBuffer[Index: MVInt]: MVFloat{TBufferedBeat} read GetMainBeatBuffer;
    //property BeatBufferX[Buffer,Index: MVInt]: TBufferedBeat read GetBeatBufferX;
    property NormBeatDiff: MVFloat{TBufferedBeat} read FNormBeatDiff;
    property AverageBeatEquality: MVFloat read GetAverageBeatEquality;

    property BeatAt[Subband,History: MVInt]: Boolean read GetBeatAt;
    property BeatEquality[History: MVInt]: MVFloat read GetBeatEquality;
    property FSAverage[Subband: MVInt]: MVFloat read GetFSAverage;
    property FSHistory[Index,Subband: MVInt]: MVFloat read GetFSHistory;
  published
    property BeatOptimizer: Boolean read FBeatOptimizer write FBeatOptimizer;
    property BPM: MVFloat read FBPM;
    property BPMAnalysisTime: MVInt read GetBPMAnalysisTime;
    property BPMFound: TBPMFoundMode read FBPMFound;
    property BPMSensibility: MVFLoat read FBPMSensibility write FBPMSensibility;
    property Channels: MVInt read FChannels write SetChannels;
    //property BB4Count: Cardinal read FBB4Count;
    property BeatBufferCount: MVInt read FBeatBufCount;
    property BeatEqualityCount: MVInt read GetBeatEqualityCount;
    property BeatHistoryCount: MVInt read GetBeatHistoryCount;
    //property BeatIterations: MVInt read FBeatIterCount {write SetBeatIterCount};
    property BeatSensibility: MVFloat read FBeatSensibility write FBeatSensibility;
    property BeatSubbandCount: MVInt read FBeatSubbandCount;
    property BufferCount: MVInt read FBufferCount write SetBufferCount;
    property BufSize: Cardinal read FBufSize;
    property FreqCount: MVInt read FFreqCount write SetFreqCount;
    property FSSensibility: MVFloat read FFSSensibility write FFSSensibility;
    //property LPeakCount: MVInt read FLPeakCount write SetLPeakCount;
    property WaveDataCount: MVInt read FWaveDataCount write SetWaveDataCount;
    property SampleRate: MVInt read FSampleRate write SetSampleRate;
  end;

type
  TSD2BufferFormat   = array [0..0] of MVFloat;
  PSD2BufferFormat   = ^TSD2BufferFormat;
  TSD2BufElem        = MVFloat;
  PSD2BufElem        = ^TSD2BufElem;

  TSD2IntBufferFormat= array [0..0] of MVInt;
  PSD2IntBufferFormat= ^TSD2IntBufferFormat;
  TSD2IntBufElem     = MVInt;
  PSD2IntBufElem     = ^TSD2IntBufElem;

  {TSD2BeatBuf        = array [0..0] of TBufferedBeat;
  PSD2BeatBuf        = ^TSD2BeatBuf;
  TSD2BeatBufElem    = TBufferedBeat;
  PSD2BeatBufElem    = ^TSD2BeatBufElem;}

  TSD2BitBufElem     = Cardinal;
  PSD2BitBufElem     = ^TSD2BitBufElem;
  TSD2BitBufFormat   = array [0..0] of TSD2BitBufElem;
  PSD2BitBufFormat   = ^TSD2BitBufFormat;

  {TSD2BeatIndex      = record
    BHIndex   : Cardinal;
    BHDown    : Boolean;
    BHLastTime: MVTime;
  end;}

  //PSD2BeatIndex      = ^TSD2BeatIndex;

function ssqr(const X: ValReal): ValReal; inline;
function cbe(const X: ValReal): ValReal; inline;
function ssqrt(const X: ValReal): ValReal; inline;
procedure ZeroMVFloat(const Buffer: Pointer; const ACount: Cardinal; const AValue: MVFloat = 0.0); inline;
//function BeatComponent(const Beat: TBufferedBeat; const Component: TBeatTag): MVFloat; inline;

function SD2Bits_Get(const Bits: PSD2BitBufFormat; const Index: MVInt): Boolean; inline;
procedure SD2Bits_Set(const Bits: PSD2BitBufFormat; const Index: MVInt); inline;
procedure SD2Bits_Reset(const Bits: PSD2BitBufFormat; const Size: MVInt); inline;
function SD2Bits_Resize(var Bits: TSD2Bits; const NewSize: MVInt; var ElementSize,OldSize: MVInt; const BufferCount: MVInt = 1): MVInt; inline;
function SD2Bits_Compare(var Bits1,Bits2: PSD2BitBufFormat; const Count,Size: MVInt): MVInt; inline;
procedure SD2Bits_Copy(const Source,Dest: PSD2BitBufFormat; const Size: MVInt); inline;

const BeatTags: array [0..4] of TBeatTag = (btPeak,btBass,btBassVocal,btTrebleVocal,btTreble);

implementation


const
  ln2                   = 0.69314718;
  SD2BufElemSize        = SizeOf(TSD2BufElem);
  {SD2BeatSize           = SizeOf(TBufferedBeat);
  SD2BeatIndexSize      = SizeOf(TSD2BeatIndex);}
  SD2BitComponentSize   = SizeOf(Cardinal);
  SD2BitComponentSizeB  = SD2BitComponentSize*8;
  SD2IntBufElemSize     = SizeOf(TSD2IntBufElem);

  PeakOffset            = 0;
  BassOffset            = 1;
  BassVocalOffset       = 2;
  TrebleVocalOffset     = 3;
  TrebleOffset          = 4;

  //SD2BeatComponentCount = 5;
  {
  MGetLevels : array [TFFTMode] of TGetLevels  = (@GetLevels_Combined_First,@GetLevels_AllChannels,@GetLevels_Combined_First);
  MGetLevelsC: array [TFFTMode] of TGetLevelsC = (@GetLevelsC_Combined_First,@GetLevelsC_AllChannels,@GetLevelsC_Combined_First);
  }

constructor TSpectrumData2.Create;
begin
  inherited Create;
  FBPMThread:=TBPMThread.Create(Self);
  //FBPMList:=TUltraSortList.Create;
  //FBPMHistoryList:=TUltraSortList.Create;
  FChannelSize:=0;
  FBufSize:=0;
  FBufsSize:=0;
  FChannels:=0;

  FNormLevel:=0.5;
  FNormBass:=0.3;
  FABeatBuf:=0;
  FTickCount:=0;
  FBeatBufCount:=0;
  //FBB4Count:=0;
  {FBeatTickStart:=0;
  FExpTickStart:=0;
  FNormBeatTicks:=30;}

  {FSBBSize:=0;
  FBBSize:=0;
  FBBSSize:=0;}
  //FBeatIterCount:=0;
  FBeatSubbandCount:=0;

  with FFSBeatBuffers do begin
    SBeatAtSize:=0;
    SBeatAtCount:=0;
    SSHSize:=0;
    SSubbandSize:=0;
    SBeatHistoryCount:=0;
    SBeatAtPos:=0;
    SBeatAtPos2:=0;
    SBeatHistorySize:=0;
    SBeatCompareCount:=1;
    SBeatEqualityCount:=0;
    SBPMContinuity:=0;
    SLastBPM:=0.0;
  end;

  FSoundEnergyAverage:=0.0;
  FBeatSensibility:=1.3;
  FFSSensibility:=3.0;
  FBPMSensibility:=1.3;
  FBPM:=0.0;
  FBPMFound:=bpmFalse;
  FBeatOptimizer:=false;
  FBPMHistoryCount:=0;
  FBPMHistoryPos:=0;

  with FBeat do begin
    Beat:=0;
    SubBeat:=0;
    Max:=3;
    //Wait:=20;
    State:=bsFound;
    Ticks:=30;
    Expected:=0;
    Free:=[btPeak..btTreble]{true};
    Togg:=[];
    Tags:=[];
    PreFree:=[btPeak..btTreble];
    //FBeatDirection:=0;
    BeatStart:=0;
    {with Sink do begin
      Peak:=0.995;
      Bass:=0.995;
      BassVocal:=0.995;
      TrebleVocal:=0.995;
      Treble:=0.995;
    end;
    with LastBeat do begin
      Peak:=0;
      Bass:=0;
      BassVocal:=0;
      TrebleVocal:=0;
      Treble:=0;
    end;
    with LastBeat2 do begin
      Peak:=30;
      Bass:=30;
      BassVocal:=30;
      TrebleVocal:=30;
      Treble:=30;
    end;
    with BeatTime do begin
      Peak:=30;
      Bass:=30;
      BassVocal:=30;
      TrebleVocal:=30;
      Treble:=30;
    end;}
  end;
  FNormBeatDiff:=0.0;
  {with FNormBeatDiff do begin
    Peak:=0.0;
    Bass:=0.0;
    BassVocal:=0.0;
    TrebleVocal:=0.0;
    Treble:=0.0;
  end;}
  {with FPreBeatDiff do begin
    Peak:=0.0;
    Bass:=0.0;
    BassVocal:=0.0;
    TrebleVocal:=0.0;
    Treble:=0.0;
  end; }
  {with FBeatDiff2 do begin
    Peak:=0.0;
    Bass:=0.0;
    BassVocal:=0.0;
    TrebleVocal:=0.0;
    Treble:=0.0;
  end;}
  FFFTMode:=fftFirst;
  FAnalyseMode:=[afFFT,afPeak];
  FDoGetLevels:=@GetLevels_Combined_First;
  FDoGetLevelsC:=@GetLevelsC_Combined_First;
  FFreqCount:=0;
end;

destructor TSpectrumData2.Destroy;
begin
  if FBufsSize>0 then FreeMem(FWDatas,FBufsSize);
  if FFBufSize>0 then begin
    FreeMem(FLevels,FFBufSize);
    FreeMem(FReBuf,FFBufSize);
    FreeMem(FImBuf,FFBufSize);
  end;
  FreeMem(FPeak,FChannels*SD2BufElemSize);
  //if FBeatBufCount>0 then FreeMem(FBeatBuffer,FBeatBufCount*SD2BeatSize);
  (***)
  //FBPMHistoryList.Destroy;
  //FBPMList.Destroy;
  FBPMThread.Terminate;
  FBPMThread.WaitFor;
  FBPMThread.Destroy;
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

procedure TSpectrumData2.Tick; inline;
begin
  Inc(FTickCount);
end;

procedure TSpectrumData2.Analyse;
var
  I             : Integer;
  APrecisionMode: TFPUPrecisionMode;
begin
  //APrecisionMode:=GetPrecisionMode;
  //SetPrecisionMode(pmSingle);
  //FFT(FReBuf,FImBuf,FFreqCount,Sign);

  DoFFT;
  DoGetPeak;
  DoGetBeat;
  DoGetBeatFS;
  //DoGetRythm;
  //DoGetBPM;
  FBPMThread.NextFrame;


  FABuffer:=succ(FABuffer) mod FBufferCount;
  FWData:=FWDatas+(FABuffer*FBufSize);


  //for I:=0 to FFreqCount-1 do FLevels[I]:=Sqrt(Sqr(FReBuf[I])+Sqr(FImBuf[I]));
  //SetPrecisionMode(APrecisionMode);
end;

procedure TSpectrumData2.CalcBandWidths;
var
  AWidthPointer       : Pointer;
  ASubbandWidth       : PSD2IntBufElem absolute AWidthPointer;
  I                   : Integer;
  a,BandRest,APreWidth: MVFloat;
begin
  AWidthPointer:=FFSBeatBuffers.SBandWidths;
  a:=FFreqCount/(FBeatSubbandCount*(FBeatSubbandCount-1)){/2*2};
  BandRest:=0;
  for I:=1 to FBeatSubbandCount do begin
    APreWidth:=(a*I)+BandRest;
    ASubbandWidth^:=Round(APreWidth);
    if ASubbandWidth^<=0 then ASubbandWidth^:=1;
    BandRest:=APreWidth-ASubbandWidth^;
    AWidthPointer+=SD2IntBufElemSize;
  end;
end;

function TSpectrumData2.InstantSoundEnergy: MVFloat;
var
  I,J    : Integer;
  AWData : Pointer;
  AWData2: ^MVFloat absolute AWData;
begin
  AWData:=FWData;
  Result:=0;
  for I:=0 to FChannels-1 do begin
    for J:=0 to FWaveDataCount-1 do begin
      Result+=sqr(AWData2^);
      AWData+=SD2BufElemSize;
    end;
  end;
  Result/=FWaveDataCount;
end;

function TSpectrumData2.SoundEnergyVariance(const ANewEnergy: MVFloat): MVFloat;
var
  I            : Integer;
  ASoundHistory: PSD2BufElem;
begin
  Result:=0;
  for I:=0 to FBeatBufCount-1 do begin
    ASoundHistory:=FSoundHistory+(((FABeatBuf+I) mod FBeatBufCount)*SD2BufElemSize);
    Result+=sqr(ASoundHistory^{.Peak}-ANewEnergy);
  end;
  Result/=FBeatBufCount;
end;

procedure TSpectrumData2.DoGetBeat; inline;
var
  ASoundHistory   : PSD2BufElem;
  {ASoundHistoryO  : PSD2BeatBufElem;
  AMainBeatBuffer : PSD2BeatBufElem;
  AMainBeatBufferO: PSD2BeatBufElem;}
  NewSoundEnergy  : MVFloat;

  procedure DGB_CompareEnergy;
  begin
    if NewSoundEnergy>FNormBeatDiff{.Peak}*FBeatSensibility then begin
      Exclude(FBeat.Free,btPeak);
      FBeat.BeatStart{.Peak}:=FTickCount;
    end else begin
      if FTickCount-FBeat.BeatStart{.Peak}>3 then Include(FBeat.Free,btPeak);
    end;
  end;

  procedure DGB_RenewEnergy;
  begin
    //ASoundHistoryO:=FSoundHistory+(FABeatBuf*SD2BeatSize);
    FABeatBuf:=(FABeatBuf+1) mod FBeatBufCount;
    ASoundHistory:=FSoundHistory+(FABeatBuf*SD2BufElemSize);
    FNormBeatDiff{.Peak}-=ASoundHistory^{.Peak}/FBeatBufCount;
    ASoundHistory^{.Peak}:=NewSoundEnergy{InstantSoundEnergy};
    FNormBeatDiff{.Peak}+=ASoundHistory^{.Peak}/FBeatBufCount;
  end;

begin
  NewSoundEnergy:=InstantSoundEnergy;
  FBeatSensibility:=(-0.0025714*SoundEnergyVariance(NewSoundEnergy))+1.5142857;
  DGB_CompareEnergy;
  DGB_RenewEnergy;
end;

procedure TSpectrumData2.DoGetBPM; {inline;}
var
  I,J,Subband,AOverCount,AHistoryIndex,AActiveIndex,AActiveIndexStart,ABPMPos,ABPMCount,ALastBPM: Integer;
  AHistory,AActive                                                                              : TSD2Bits;
  ABufPointer                                                                                   : Pointer;
  ABuf                                                                                          : PSD2BufElem absolute ABufPointer;
  AAverageBeatEquality,ABPMFac                                                                  : MVFloat;
  ABufVal,ALastBufVal                                                                           : TSD2BufElem;
  AHistoryBufPointer                                                                            : Pointer;
  AHistoryBuf                                                                                   : PSD2BufElem absolute AHistoryBufPointer;
begin
  AActiveIndexStart:=FFSBeatBuffers.SBeatAtPos2+1+(FFSBeatBuffers.SBeatHistoryCount-FFSBeatBuffers.SBeatCompareCount);
  ABufPointer:=FFSBeatBuffers.SBeatEquality;
  AAverageBeatEquality:=0.0;
  ABPMPos:=0;
  ALastBPM:=0;
  ABPMCount:=0;
  ALastBufVal:=0.0;
  ABPMFac:=(FSampleRate*60)/FWaveDataCount;
  //FBPMThread.FBPMList.Clear;
  for I:=0 to FFSBeatBuffers.SBeatEqualityCount-1 do begin
    AOverCount:=0;
    ABufVal:=0.0;
    {AHistoryIndex:=(FFSBeatBuffers.SBeatAtPos+1+I+J) mod FFSBeatBuffers.SBeatAtCount;
    AHistory:=FFSBeatBuffers.SBeatAtHistory+(FFSBeatBuffers.SBeatAtSize*AHistoryIndex);}
    //ABuf^:=I;
    for J:=0 to FFSBeatBuffers.SBeatCompareCount-1 do begin;

      AHistoryIndex:=(FFSBeatBuffers.SBeatAtPos2+1+I+J) mod FFSBeatBuffers.SBeatHistoryCount;
      AHistory:=FFSBeatBuffers.SBeatAtHistory2+(FFSBeatBuffers.SBeatAtSize*AHistoryIndex);

      AActiveIndex:=(AActiveIndexStart+J) mod FFSBeatBuffers.SBeatHistoryCount;
      AActive:=FFSBeatBuffers.SBeatAtHistory2+(FFSBeatBuffers.SBeatAtSize*AActiveIndex);

      //for Subband:=0 to FFSBeatBuffers.SBeatAtCount-1 do begin
      ABufVal+=SD2Bits_Compare(AHistory,AActive,FFSBeatBuffers.SBeatAtCount,FBeatSubbandCount);
      //end;
    end;
    //ABuf^:=sqr(ABuf^);
    if ABufVal<ALastBufVal
      then ABuf^:=0.0
      else ABuf^:=sqr({sqr}(ABufVal)-{sqr}(ALastBufVal));
    //ABuf^:=(sqr(ABufVal)-sqr(ALastBufVal))*0.1;
    //if ABuf^<0.0 then ABuf^:=0.0;
    //ABuf^:=ABufVal;

    if ABuf^>FFSBeatBuffers.SAverageBeatEquality*FBPMSensibility then begin
      if I-ABPMPos>5 then begin
        Inc(ABPMCount);
        //FBPMThread.FBPMList.AddBPM(ABPMFac/(I-ABPMPos),I-ABPMPos); {ALastBPM ???}
        ALastBPM:=I;
        //APreBPM+=I-ALastBPM;
      end;
      ABPMPos:=I;
    end;
    ALastBufVal:=ABufVal;
    AAverageBeatEquality+=ABuf^;
    ABufPointer+=SD2BufElemSize;
  end;

  AAverageBeatEquality/=FFSBeatBuffers.SBeatEqualityCount;
  FFSBeatBuffers.SAverageBeatEquality:=AAverageBeatEquality;

  //ABPMCount-=1;
  if ABPMCount>0 then begin
    //FBPM:=(FSampleRate/((ALastBPM/ABPMCount)*FWaveDataCount))*60;
    if FBeatOptimizer then begin
      //FBPMList.FindBPM(FBPMThread.FramesNeeded);
      //FBPM:=FBPMList.BPM;
      FBPM:=120;
    end else FBPM:=ABPMFac/(ABPMPos/ABPMCount);
    if abs(FFSBeatBuffers.SLastBPM-FBPM)<0.1
      then Inc(FFSBeatBuffers.SBPMContinuity)
      else FFSBeatBuffers.SBPMContinuity:=0;
    //FBPM:=(1/((FWaveDataCount/FSampleRate)*(ALastBPM/ABPMCount)))*60;
    //FBPMFound:=bpmTrue;
    FBPMFound:=TBPMFoundMode((FBPM>10.0) and (FBPM<1000.0));
    if Boolean(FBPMFound) then begin
      if FFSBeatBuffers.SBPMContinuity<3000 then FBPMFound:=bpmScanning;
    end;
  end else begin
    FBPM:=0.0;
    FBPMFound:=bpmFalse;
  end;
  FFSBeatBuffers.SLastBPM:=FBPM;
  {FBPMHistoryPos:=(FBPMHistoryPos+1) mod FBPMHistoryCount;
  AHistoryBufPointer:=FBPMHistory+(FBPMHistoryPos*SD2BufElemSize);}

  {FBPMHistoryList.DeleteBPM(AHistoryBuf^);
  AHistoryBuf^:=FBPM;
  FBPMHistoryList.AddBPM(AHistoryBuf^,1);}
end;

{procedure TSpectrumData2.DoGetRythm; inline;
begin

end;}

procedure TSpectrumData2.DoGetBeatFS; inline;
var
  I,J,ASubbandFreqCount                : Integer;
  ASubband,ASoundEnergy                : MVFloat;
  AASEPointer,AISEPointer,AWidthPointer: Pointer;
  AAverageEnergy                       : PSD2BufElem absolute AASEPointer;
  AInstantEnergy                       : PSD2BufElem absolute AISEPointer;
  ASubbandWidth                        : PSD2IntBufElem absolute AWidthPointer;

  function GetSubband: MVFloat;
  var
    OldJ: Integer;
  begin
    Result:=0.0;
    OldJ:=J;
    repeat
      Result+=sqr(GetLevels(J,0));
      Inc(J);
    until J>=OldJ+ASubbandWidth^{(I+1)*ASubbandFreqCount}{OldJ+ASubbandFreqCount};
    //Result/=ASubbandWidth^{ASubbandFreqCount};
    //ShowMessage(IntToStr(ASubbandWidth^));
    {if I<16
      then Result:=sqr(GetLevels(I,0))
      else Result:=sqr(GetLevels((FFreqCount-1)-(31-I),0));}
  end;

begin
  ASubbandFreqCount:=FFreqCount div FBeatSubbandCount;
  J:=0;
  with FFSBeatBuffers do begin
    AASEPointer:=SAverageSoundEnergys;
    AISEPointer:=SSubbandHistory+(FABeatBuf*SSubbandSize);

    SBeatAtPos:=(SBeatAtPos+1) mod SBeatHistoryCount;
    SIsBeatAt:=SBeatAtHistory+(SBeatAtSize*SBeatAtPos);

    SD2Bits_Reset(SIsBeatAt,SBeatAtCount);
    AWidthPointer:=SBandWidths;
  end;
  for I:=0 to FBeatSubbandCount-1 do begin
    ASubband:=GetSubband;
    if ASubband>AAverageEnergy^*FFSSensibility then SD2Bits_Set(FFSBeatBuffers.SIsBeatAt,I);

    AAverageEnergy^+=((ASubband/FBeatBufCount)-(AInstantEnergy^/FBeatBufCount));
    AInstantEnergy^:=ASubband;

    AASEPointer+=SD2BufElemSize;
    AISEPointer+=SD2BufElemSize;
    AWidthPointer+=SD2IntBufElemSize;
  end;
end;

(*procedure TSpectrumData2.DoGetBeatOld0;
var
  ASoundHistory   : PSD2BeatBufElem;
  ASoundHistoryO  : PSD2BeatBufElem;
  AMainBeatBuffer : PSD2BeatBufElem;
  AMainBeatBufferO: PSD2BeatBufElem;

  procedure GetSoundArea(var Dest: MVFloat; const Start,Stop: Integer);
  var
    I: Integer;
  begin
    Dest:=0.0;
    for I:=Start to Stop do Dest+=GetLevels(I,0);
  end;

  procedure FillSoundHistory;
  var
    AreaStep        : Integer;
  begin
    AreaStep:=FFreqCount div 16;

    ASoundHistoryO:=FSoundHistory+(FABeatBuf*SD2BeatSize);
    AMainBeatBufferO:=FMainBeatBuffer+(FABeatBuf*SD2BeatSize);

    FABeatBuf:=(FABeatBuf+1) mod FBeatBufCount;

    ASoundHistory:=FSoundHistory+(FABeatBuf*SD2BeatSize);
    AMainBeatBuffer:=FMainBeatBuffer+(FABeatBuf*SD2BeatSize);

    with ASoundHistory^ do begin
      Bass:=GetLevels(0,0);
      //GetSoundArea(Bass,0,AreaStep-1);
      GetSoundArea(BassVocal,AreaStep,(AreaStep*4)-1);
      GetSoundArea(TrebleVocal,AreaStep*4,(AreaStep*10)-1);
      GetSoundArea(Treble,AreaStep*10,(AreaStep*16)-1);
      Peak:=GetPeak(0);
    end;

    //AMainBeatBuffer^:=ASoundHistory^;
    with AMainBeatBuffer^ do begin
      Bass:={cbe}(ASoundHistory^.Bass-ASoundHistoryO^.Bass);
      BassVocal:={cbe}(ASoundHistory^.BassVocal-ASoundHistoryO^.BassVocal);
      TrebleVocal:={cbe}(ASoundHistory^.TrebleVocal-ASoundHistoryO^.TrebleVocal);
      Treble:={cbe}(ASoundHistory^.Treble-ASoundHistoryO^.Treble);
      Peak:={cbe}(ASoundHistory^.Peak-ASoundHistoryO^.Peak);
    end;
  end;

  function FindHighest(const Buffer: TSD2WData; var LastOldVal,LastNewVal,DelVal,AddVal: MVFloat; out LastTime: MVTime): Boolean;
  var
    ABufHeader: PSD2BeatIndex absolute Buffer;
    ABuffer   : PSD2BufElem;
    ABufferO  : PSD2BufElem;
    //ABufNewVal: MVFloat;
  begin
    with ABufHeader^ do begin
      ABufferO:=Buffer+SD2BeatIndexSize+(BHIndex*SD2BufElemSize);
      //ABufNewVal:=
      if BHDown then begin
        if LastNewVal>LastOldVal then BHDown:=false;
      end else begin
        if LastNewVal<LastOldVal then begin
          BHDown:=true;
          BHIndex:=(BHIndex+1) mod FBB4Count;
          ABuffer:=Buffer+SD2BeatIndexSize+(BHIndex*SD2BufElemSize);
          DelVal:=ABuffer^;
          ABuffer^:=LastOldVal;
          AddVal:=ABuffer^;
          Result:=true;

          LastOldVal:=ABufferO^;
          LastNewVal:=ABuffer^;

          LastTime:=BHLastTime;
          BHLastTime:=FTickCount;
          exit;
        end;
      end;
    end;
    Result:=false;
  end;

  procedure CheckBeat(const MainBuffer,ANorm: MVFloat; var ALastBeat1,ALastBeat2,ABeatTime,ABeatStart: MVTime; const AFree: TBeatTag);
  begin
    if AFree in FBeat.Free then begin
      if MainBuffer>=ANorm then begin
        Exclude(FBeat.Free,AFree);
        ABeatStart:=FTickCount;
      end;
    end else begin
      if MainBuffer<ANorm then if FTickCount-ABeatStart>=3 then Include(FBeat.Free,AFree);
    end;
    {if (FTickCount-ALastBeat1) mod ABeatTime=0 then begin
      ABeatStart:=FTickCount;
      Include(FBeat.Free,AFree);
    end;
    if (AFree in FBeat.Free) and (FTickCount-ABeatStart>=5) then Exclude(FBeat.Free,AFree);}
  end;

  procedure DoBeatIterate(const Buffer: TSD2WData; const MainBufferO,MainBuffer: MVFloat; var ALastBeat1,ALastBeat2,ABeatTime,ABeatStart: MVTime; const AFree: TBeatTag; var APreNorm,ANorm: MVFloat);
  var
    ALastOldVal,ALastNewVal: MVFloat;
    ABeatBuffer            : TSD2WData;
    I                      : Integer;
    ALastTime              : MVTime;
    ADelVal,AAddVal        : MVFloat;
  begin
    CheckBeat(MainBuffer,ANorm,ALastBeat1,ALastBeat2,ABeatTime,ABeatStart,AFree);

    I:=0;
    if I<FBeatIterCount then begin
      ALastOldVal:=MainBufferO;
      ALastNewVal:=MainBuffer;
      ABeatBuffer:=Buffer;
      while FindHighest(ABeatBuffer,ALastOldVal,ALastNewVal,ADelVal,AAddVal,ALastTime) do begin
        Inc(I);
        if I>=FBeatIterCount then begin
          if ALastTime>ALastBeat1 then begin
            ALastBeat2:=ALastBeat1;
            ALastBeat1:=ALastTime;
            ABeatTime:=ALastBeat1-ALastBeat2;
            APreNorm+=sqr(AAddVal)/FBB4Count-sqr(ADelVal)/FBB4Count;
            ANorm:=sqrt(Abs(APreNorm));
          end;
          exit;
        end;
        ABeatBuffer+=FBBSize;
      end;
    end;
  end;

begin
  FillSoundHistory;
  {
  DoBeatIterate(FBeatBuffers+(PeakOffset*FSBBSize),AMainBeatBufferO^.Peak,AMainBeatBuffer^.Peak,FBeat.LastBeat.Peak,FBeat.LastBeat2.Peak,FBeat.BeatTime.Peak,FBeat.BeatStart.Peak,btPeak,FPreBeatDiff.Peak,FNormBeatDiff.Peak);
  DoBeatIterate(FBeatBuffers+(BassOffset*FSBBSize),AMainBeatBufferO^.Bass,AMainBeatBuffer^.Bass,FBeat.LastBeat.Bass,FBeat.LastBeat2.Bass,FBeat.BeatTime.Bass,FBeat.BeatStart.Bass,btBass,FPreBeatDiff.Bass,FNormBeatDiff.Bass);
  DoBeatIterate(FBeatBuffers+(BassVocalOffset*FSBBSize),AMainBeatBufferO^.BassVocal,AMainBeatBuffer^.BassVocal,FBeat.LastBeat.BassVocal,FBeat.LastBeat2.BassVocal,FBeat.BeatTime.BassVocal,FBeat.BeatStart.BassVocal,btBassVocal,FPreBeatDiff.BassVocal,FNormBeatDiff.BassVocal);
  DoBeatIterate(FBeatBuffers+(TrebleVocalOffset*FSBBSize),AMainBeatBufferO^.TrebleVocal,AMainBeatBuffer^.TrebleVocal,FBeat.LastBeat.TrebleVocal,FBeat.LastBeat2.TrebleVocal,FBeat.BeatTime.TrebleVocal,FBeat.BeatStart.TrebleVocal,btTrebleVocal,FPreBeatDiff.TrebleVocal,FNormBeatDiff.TrebleVocal);
  DoBeatIterate(FBeatBuffers+(TrebleOffset*FSBBSize),AMainBeatBufferO^.Treble,AMainBeatBuffer^.Treble,FBeat.LastBeat.Treble,FBeat.LastBeat2.Treble,FBeat.BeatTime.Treble,FBeat.BeatStart.Treble,btTreble,FPreBeatDiff.Treble,FNormBeatDiff.Treble);
  }
end;*)

(*procedure TSpectrumData2.DoGetBeatOld;
var
  BeatTicks               : Cardinal;
  TickSpace               : Cardinal;
  ASpeed                  : MVFloat;
  J                       : Integer;
  AreaStep                : Integer;
  Weight                  : MVFloat;
  //ABeat    : TBufferedBeat;
  ABeatBuffer1            : PSD2BeatBufElem;
  ABeatBuffer1o           : PSD2BeatBufElem;
  ABeatBuffer2            : PSD2BeatBufElem;
  ABeatBuffer2o           : PSD2BeatBufElem;
  ABeatBuffer3            : PSD2BeatBufElem;
  ABeatBuffer3o           : PSD2BeatBufElem;
  ABeatBuffer4            : PSD2BeatBufElem;
  ABeatBuffer4o           : PSD2BeatBufElem;
  BB3NewPos               : Cardinal;
  BB3NewVal               : MVFloat;

  //ADiff                   : TBufferedBeat;
  //NewBeatTags,AntiBeatTags: TBeatTags;
//  Bass,BassVocal,TrebleVocal,Treble: MVFloat;

  procedure GetSoundArea(var Dest: MVFloat; const Start,Stop: Integer);
  var
    I: Integer;
  begin
    Dest:=0.0;
    for I:=Start to Stop do Dest+=GetLevels(I,0);
  end;

  (*procedure CheckInclude(const IncludeVal: TBeatTag; const Default,Diff: MVFloat);
  begin
    if Diff>(Default*2) then begin
      {if FBeat.Free then }Include(NewBeatTags,IncludeVal);
      FBeat.Free:=true;
    end else (*if Diff<=1{Default}{/2} then Include(AntiBeatTags,IncludeVal)*);
  end;*)

  procedure CheckInclude(const BTag: TBeatTag; const Active,Old,{ActiveR,OldR,}ASink: MVFloat; var Norm: MVFloat; var ALastBeatTicks: UInt64);
  begin
    {with ABeatBuffer2^ do }with FBeat do begin
      if ((FTickCount-ALastBeatTicks)>=5) then begin
        if Active>=Norm then begin
          if {FBeat.Free} (BTag in Free) then begin
            if BTag in Togg
              then Togg-=[BTag]
              else Include(Togg,BTag);
            //FBeat.Togg:= not FBeat.Togg;
            ALastBeatTicks:=FTickCount;
            Free-=[BTag];
            //Include(Free,BTag)
            //FBeat.Free:=false;
          end;
        end else Include(Free,BTag);//Free-=[BTag]{FBeat.Free:=true};
      end;

      (*Weight:={Abs(}{ssqrt}Active{-ABeatBuffer2o^.Peak)};
      Norm:=((Norm*(1-Weight))+({ssqrt}(Active-Old)*Weight))*ASink;*)

      (*Weight:={Abs(}{ssqrt}Active{-ABeatBuffer2o^.Peak)};
      Norm:=((Norm*(1-Weight))+({ssqrt}(ActiveR-OldR)*Weight))*ASink;*)
    end;
  end;

begin
  //Dec(FBeat.Wait);
  AreaStep:=FFreqCount div 16;

  ABeatBuffer1o:=FBeatBuffer+(FABeatBuf*SD2BeatSize);
  ABeatBuffer2o:=FBeatBuffer2+(FABeatBuf*SD2BeatSize);
  //ABeatBuffer3o:=FBeatBuffer3+(FABeatBuf*SD2BeatSize);

  FABeatBuf:=(FABeatBuf+1) mod FBeatBufCount;

  ABeatBuffer1:=FBeatBuffer+(FABeatBuf*SD2BeatSize);
  ABeatBuffer2:=FBeatBuffer2+(FABeatBuf*SD2BeatSize);
  //ABeatBuffer3:=FBeatBuffer3+(FABeatBuf*SD2BeatSize);

  with ABeatBuffer1^ do begin
    GetSoundArea(Bass,0,AreaStep-1);
    GetSoundArea(BassVocal,AreaStep,(AreaStep*4)-1);
    GetSoundArea(TrebleVocal,AreaStep*4,(AreaStep*10)-1);
    GetSoundArea(Treble,AreaStep*10,(AreaStep*16)-1);
    Peak:=GetPeak(0);
  end;

  {with  ABeatBuffer3^ do begin
    Bass:=ABeatBuffer1^.Bass-ABeatBuffer1o^.Bass;
    BassVocal:=ABeatBuffer1^.BassVocal-ABeatBuffer1o^.BassVocal;
    TrebleVocal:=ABeatBuffer1^.TrebleVocal-ABeatBuffer1o^.TrebleVocal;
    Treble:=ABeatBuffer1^.Treble-ABeatBuffer1o^.Treble;
    Peak:=ABeatBuffer1^.Peak-ABeatBuffer1o^.Peak;
  end;}

  with ABeatBuffer2^ do begin
    Bass:=cbe({ABeatBuffer3^.Bass}ABeatBuffer1^.Bass-ABeatBuffer1o^.Bass);
    BassVocal:=cbe({ABeatBuffer3^.BassVocal}ABeatBuffer1^.BassVocal-ABeatBuffer1o^.BassVocal);
    TrebleVocal:=cbe({ABeatBuffer3^.TrebleVocal}ABeatBuffer1^.TrebleVocal-ABeatBuffer1o^.TrebleVocal);
    Treble:=cbe({ABeatBuffer3^.Treble}ABeatBuffer1^.Treble-ABeatBuffer1o^.Treble);
    Peak:=cbe({ABeatBuffer3^.Peak}ABeatBuffer1^.Peak-ABeatBuffer1o^.Peak);

    CheckInclude(btPeak,Peak,ABeatBuffer2o^.Peak{,ABeatBuffer3^.Peak,ABeatBuffer3o^.Peak},FBeat.Sink.Peak,FNormBeatDiff.Peak,FBeat.LastBeat.Peak);
    CheckInclude(btBass,Bass,ABeatBuffer2o^.Bass{,ABeatBuffer3^.Bass,ABeatBuffer3o^.Bass},FBeat.Sink.Bass,FNormBeatDiff.Bass,FBeat.LastBeat.Bass);
    CheckInclude(btBassVocal,BassVocal,ABeatBuffer2o^.BassVocal{,ABeatBuffer3^.BassVocal,ABeatBuffer3o^.BassVocal},FBeat.Sink.BassVocal,FNormBeatDiff.BassVocal,FBeat.LastBeat.BassVocal);
    CheckInclude(btTrebleVocal,TrebleVocal,ABeatBuffer2o^.TrebleVocal{,ABeatBuffer3^.TrebleVocal,ABeatBuffer3o^.TrebleVocal},FBeat.Sink.TrebleVocal,FNormBeatDiff.TrebleVocal,FBeat.LastBeat.TrebleVocal);
    CheckInclude(btTreble,Treble,ABeatBuffer2o^.Treble{,ABeatBuffer3^.Treble,ABeatBuffer3o^.Treble},FBeat.Sink.Treble,FNormBeatDiff.Treble,FBeat.LastBeat.Treble);

  end;

  //with ABeatBuffer3^ do begin
  //ABeatBuffer3o:=FBeatBuffer3+(FBB3Pos*SD2BeatSize);
  BB3NewPos:=(FBB3Pos.Peak+1) mod FBeatBufCount;
  ABeatBuffer3:=FBeatBuffer3+({FABeatBuf}BB3NewPos*SD2BeatSize);
  //BB3NewVal:=ABeatBuffer2^.Peak-ABeatBuffer2^.Peak;
  if Boolean((FBeatDirection shr PeakOffset) and 1) then begin
    if (ABeatBuffer2^.Peak-ABeatBuffer2o^.Peak)<0 then begin
      FBeatDiff2.Peak-=sqr(sqr(ABeatBuffer3^.Peak/FBeatBufCount));
      ABeatBuffer3^.Peak:=ABeatBuffer2o^.Peak;
      FBeatDiff2.Peak+=sqr(sqr(ABeatBuffer3^.Peak/FBeatBufCount));

      FPreBeatDiff.Peak:=sqrt(Abs(sqrt(Abs(FBeatDiff2.Peak))));
      FBB3Pos.Peak:=BB3NewPos;
      FBeatDirection:=FBeatDirection xor (1 shl PeakOffset);

      if ABeatBuffer2o^.Peak>FPreBeatDiff.Peak then begin
        {if btPeak in FBeat.PreFree then begin
          //Exclude(FBeat.PreFree,btPeak);

          FBB4Pos.Peak:=(FBB4Pos.Peak+1) mod FBB4Count;
          ABeatBuffer4:=FBeatBuffer4+(FBB4Pos.Peak*SD2BeatSize);

          FNormBeatDiff.Peak-=ABeatBuffer4^.Peak/(FBB4Count*1);
          ABeatBuffer4^.Peak:=ABeatBuffer2o^.Peak;
          FNormBeatDiff.Peak+=ABeatBuffer4^.Peak/(FBB4Count*1);
        end else if ABeatBuffer4^.Peak>ABeatBuffer2o^.Peak then begin
          FNormBeatDiff.Peak-=ABeatBuffer4^.Peak/(FBB4Count*1);
          ABeatBuffer4^.Peak:=ABeatBuffer2o^.Peak;
          FNormBeatDiff.Peak+=ABeatBuffer4^.Peak/(FBB4Count*1);
        end;}
        FBB4Pos.Peak:=(FBB4Pos.Peak+1) mod FBB4Count;
        ABeatBuffer4:=FBeatBuffer4+(FBB4Pos.Peak*SD2BeatSize);

        FNormBeatDiff.Peak-=ABeatBuffer4^.Peak/(FBB4Count*1);
        ABeatBuffer4^.Peak:=ABeatBuffer2o^.Peak;
        FNormBeatDiff.Peak+=ABeatBuffer4^.Peak/(FBB4Count*1);

        //FNormBeatDiff.Peak:=FBeatDiff2.Peak;
      end else Include(FBeat.PreFree,btPeak);
    end;
  end else begin
    if (ABeatBuffer2^.Peak-ABeatBuffer2o^.Peak)>0 then begin
      {ABeatBuffer3^.Peak:=ABeatBuffer2^.Peak;
      FBB3Pos:=BB3NewPos;}
      FBeatDirection:=FBeatDirection xor (1 shl PeakOffset);
    end;
  end;
  //end;




  {with ABeatBuffer3^ do begin
    Bass:=cbe(ABeatBuffer2^.Bass-ABeatBuffer2o^.Bass);
    BassVocal:=cbe(ABeatBuffer2^.BassVocal-ABeatBuffer2o^.BassVocal);
    TrebleVocal:=cbe(ABeatBuffer2^.TrebleVocal-ABeatBuffer2o^.TrebleVocal);
    Treble:=cbe(ABeatBuffer2^.Treble-ABeatBuffer2o^.Treble);
    Peak:=cbe(ABeatBuffer2^.Peak-ABeatBuffer2o^.Peak);
  end;}

  {ABeatBuffer:=FBeatBuffer2+(FABeatBuf*SD2BeatSize);
  ABeatBuffer^:=ADiff;}

  {with ADiff do begin
    Bass:=0.0;
    BassVocal:=0.0;
    TrebleVocal:=0.0;
    Treble:=0.0;
    Peak:=0.0;
  end;

  ABeatBuffer:=FBeatBuffer+(((FABeatBuf+1) mod FBeatBufCount)*SD2BeatSize);
  for J:=2 to FBeatBufCount do begin
    ABeatBuffer2:=ABeatBuffer;
    ABeatBuffer:=FBeatBuffer+(((FABeatBuf+J) mod FBeatBufCount)*SD2BeatSize);

    ADiff.Bass+=ssqr(ABeatBuffer^.Bass-ABeatBuffer2^.Bass);
    ADiff.BassVocal+=ssqr(ABeatBuffer^.BassVocal-ABeatBuffer2^.BassVocal);
    ADiff.TrebleVocal+=ssqr(ABeatBuffer^.TrebleVocal-ABeatBuffer2^.TrebleVocal);
    ADiff.Treble+=ssqr(ABeatBuffer^.Treble-ABeatBuffer2^.Treble);
    ADiff.Peak+=ssqr(ABeatBuffer^.Peak-ABeatBuffer2^.Peak);
  end;

  ABeatBuffer:=FBeatBuffer2+(FABeatBuf*SD2BeatSize);
  ABeatBuffer^:=ADiff;

  NewBeatTags:=[];
  AntiBeatTags:=[];}



  {if ADiff.Bass>(FNormBeatHeight.Bass*2) then begin
    if FBeat.Free then begin
      FBeat.Free:=false;
      Include(NewBeatTags,btBass);
    end;
  end else if ADiff.Bass<=FNormBeatHeight.Bass/2 then FBeat.Free:=true;}

  {CheckInclude(btPeak,FNormBeatHeight.Peak,ADiff.Peak);
  CheckInclude(btBass,FNormBeatHeight.Bass,ADiff.Bass);
  CheckInclude(btBassVocal,FNormBeatHeight.BassVocal,ADiff.BassVocal);
  CheckInclude(btTrebleVocal,FNormBeatHeight.TrebleVocal,ADiff.TrebleVocal);
  CheckInclude(btTreble,FNormBeatHeight.Treble,ADiff.Treble);

  if NewBeatTags<>[] then begin
    if FBeat.Free then begin
      if btPeak in NewBeatTags then begin
        FBeat.Togg:= not FBeat.Togg;
        FBeat.Tags:=NewBeatTags;
        FBeat.Free:=false;
      end;
    end;
  end else begin
    if AntiBeatTags=[btPeak,btBass,btBassVocal,btTrebleVocal,btTreble] then begin
      FBeat.Free:=true;
    end;

  end;
    FNormBeatHeight.Bass:=((FNormBeatHeight.Bass*255)+ADiff.Bass)/256;
    FNormBeatHeight.BassVocal:=((FNormBeatHeight.BassVocal*255)+ADiff.BassVocal)/256;
    FNormBeatHeight.TrebleVocal:=((FNormBeatHeight.TrebleVocal*255)+ADiff.TrebleVocal)/256;
    FNormBeatHeight.Treble:=((FNormBeatHeight.Treble*255)+ADiff.Treble)/256;
    FNormBeatHeight.Peak:=((FNormBeatHeight.Peak*255)+ADiff.Peak)/256; }

  (*Dec(FBeat.Wait);
  if FTickCount-FExpTickStart>=FBeat.Ticks then begin
    FBeat.Expected:=(FBeat.Expected+1) mod 4;
    FExpTickStart:=FTickCount;
  end;
  with FBeat do if (GetPeak(0)>=FNormLevel*1.5) and (Wait<=0) then begin
    BeatTicks:=FTickCount-FBeatTickStart;
    Togg:=not Togg;
    //Beat:=(Beat{Expected}+1) mod 4;
    {if Beat=Expected
      then Beat:=(Expected+1) mod 4
      else Beat:=Expected;}
    Wait:=20;
    TickSpace:=Ticks{FNormBeatTicks} div 3;
    if (BeatTicks>TickSpace*2) and (BeatTicks<TickSpace*5) then begin
      //Beat:=Expected;
      Ticks:=((Ticks*2)+BeatTicks) div 3;
      FExpTickStart:=FTickCount;
    end{ else Beat:=(Beat+1) mod 4};
    if Beat=Expected
      then Beat:=(Beat+1) mod 4
      else Beat:=Expected;
    //  FBeatTickStart:=FTickCount;

    {ASpeed:=BeatTicks/Ticks;
    if Abs(FLastSpeed-ASpeed)< then begin

      Inc(FSpeedCount);
    end else begin
      FLastSpeed:=ASpeed;
      FSpeedCount:=1;
    end;}

    {FSpeedIndex:=(FSpeedIndex+1) mod FSpeedCount;
    FASpeedBuf:=FSpeedBuf+(FSpeedIndex*SD2BufElemSize);
    FASpeedBuf^:=}

    FNormBeatTicks:=((FNormBeatTicks*255)+(BeatTicks)) div 256;

    FBeatTickStart:=FTickCount;
  end;
  FNormLevel:=((FNormLevel*255)+GetPeak(0))/256;
  //FNormBass:=((FNormBass*511)+GetLevels(0,0))/512;*)
end;  *)

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
  I,J    : Integer;
  APeak  : Pointer;
  AWData : Pointer;
  APeak2 : ^MVFloat absolute APeak;
  AWData2: ^MVFloat absolute AWData;
  Temp   : MVFloat;
begin
  APeak:=FPeak;
  AWData:=FWData;
  for I:=0 to FChannels-1 do begin
    APeak2^:=0;
    for J:=0 to FWaveDataCount-1 do begin
      //APeak2^+=Abs(AWData2^);
      Temp:=Abs(AWData2^);
      if Temp>APeak2^ then APeak2^:=Temp;
      AWData+=SD2BufElemSize;
    end;
    //APeak2^/=FWaveDataCount;
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


procedure TSpectrumData2.SetCounts(const AChannels,AWaveDataCount,AFreqCount,ABufferCount,ABeatBufCount,ABB4Count,ABeatIterCount,ABeatSubbandCount,ABeatHistoryCount,ABeatCompareCount,ABPMHistoryCount: Cardinal);

  {procedure FillBeatBuf(var BeatBuf: TSD2WData; const ACount: Integer);
  var
    I   : Integer;
    ABuf: PSD2BeatBuf absolute BeatBuf;
  begin
    for I:=0 to ACount-1 do with ABuf^[I] do begin
      Peak:=0.0;
      Bass:=0.0;
      BassVocal:=0.0;
      TrebleVocal:=0.0;
      Treble:=0.0;
    end;
  end;}

  {procedure FillBeatBufs(var BeatBufs: TSD2WData);

    procedure FillBeatBufs_Internal(var BeatBuf: TSD2WData);
    var
      ABuf: PSD2BeatIndex absolute BeatBuf;
    begin
      with ABuf^ do begin
        BHIndex:=0;
        BHDown:=false;
        BHLastTime:=FTickCount;
      end;
      ZeroMVFloat(BeatBuf+SD2BeatIndexSize,FBB4Count);
    end;

  var
    I    : Integer;
    AABuf: TSD2WData;
  begin
    AABuf:=BeatBufs;
    for I:=0 to (ABeatIterCount*SD2BeatComponentCount)-1 do begin
      FillBeatBufs_Internal(AABuf);
      AABuf+=FSBBSize;
    end;
  end;}

var
  ASBeatHistorySize,ASBeatAtSize: MVInt;
begin
  if FBufsSize>0 then FreeMem(FWDatas,FBufsSize);
  if FFBufSize>0 then begin
    FreeMem(FLevels,FFBufSize);
    FreeMem(FReBuf,FFBufSize);
    FreeMem(FImBuf,FFBufSize);
  end;
  if FChannels>0 then FreeMem(FPeak,FChannels*SD2BufElemSize);
  if FBeatBufCount>0 then begin
    {FreeMem(FBeatBuffer,FBeatBufCount*SD2BeatSize);
    FreeMem(FBeatBuffer2,FBeatBufCount*SD2BeatSize);
    FreeMem(FBeatBuffer3,FBeatBufCount*SD2BeatSize);}
    FreeMem(FSoundHistory,FBeatBufCount*SD2BufElemSize);
    FreeMem(FMainBeatBuffer,FBeatBufCount*SD2BufElemSize);
  end;
  {if FBB4Count>0 then begin
    FreeMem(FBeatBuffer4,FBB4Count*SD2BeatSize);
  end;}


  with FFSBeatBuffers do begin
    if FBeatSubbandCount>0 then begin
      FreeMem(SAverageSoundEnergys,FBeatSubbandCount*SD2BufElemSize);
      FreeMem(SBandWidths,FBeatSubbandCount*SD2IntBufElemSize);
    end;
    if SSHSize>0 then FreeMem(SSubbandHistory,SSHSize);
    if SBeatEqualityCount>0 then FreeMem(SBeatEquality,SBeatEqualityCount*SD2BufElemSize);
  end;

  if FBPMHistoryCount>0 then FreeMem(FBPMHistory,FBPMHistoryCount*SD2BufElemSize);

  FNormBeatDiff:=0.0;
  {with FNormBeatDiff do begin
    Peak:=0.0;
    Bass:=0.0;
    BassVocal:=0.0;
    TrebleVocal:=0.0;
    Treble:=0.0;
  end;
  with FPreBeatDiff do begin
    Peak:=0.0;
    Bass:=0.0;
    BassVocal:=0.0;
    TrebleVocal:=0.0;
    Treble:=0.0;
  end;}
  FSoundEnergyAverage:=0.0;

  //if FBBSSize>0 then FreeMem(FBeatBuffers,FBBSSize);

  FABuffer:=0;
  FABeatBuf:=0;

  {with FBB3Pos do begin
    Peak:=0;
    Bass:=0;
    BassVocal:=0;
    TrebleVocal:=0;
    Treble:=0;
  end;

  with FBB4Pos do begin
    Peak:=0;
    Bass:=0;
    BassVocal:=0;
    TrebleVocal:=0;
    Treble:=0;
  end;

  with FNormBeatDiff do begin
    Peak:=0.0;
    Bass:=0.0;
    BassVocal:=0.0;
    TrebleVocal:=0.0;
    Treble:=0.0;
  end; }

  FChannelSize:=AWaveDataCount*SD2BufElemSize;
  FBufSize:=FChannelSize*AChannels;
  FBufsSize:=FBufSize*ABufferCount;
  FFChannelSize:=AFreqCount*SD2BufElemSize;
  case FFFTMode of
    fftCombined   : FFBufSize:=FFChannelSize;
    fftAllChannels: FFBufSize:=FFChannelSize*AChannels;
    fftFirst      : FFBufSize:=FFChannelSize;
  end;

  {FSBBSize:=(ABB4Count*SD2BufElemSize)+SD2BeatIndexSize;
  FBBSize:=FSBBSize*SD2BeatComponentCount;
  FBBSSize:=FBBSize*ABeatIterCount; }

  FChannels:=AChannels;
  FWaveDataCount:=AWaveDataCount;
  FFreqCount:=AFreqCount;
  FBufferCount:=ABufferCount;
  FBeatBufCount:=ABeatBufCount;
  //FBB4Count:=ABB4Count;
  //FBeatIterCount:=ABeatIterCount;

  FBPMHistoryCount:=ABPMHistoryCount;
  FBPMHistoryPos:=0;

  with FFSBeatBuffers do begin
    ASBeatHistorySize:=SBeatHistorySize;
    ASBeatAtSize:=SBeatAtSize;
    SBeatAtCount:=SD2Bits_Resize(SBeatAtHistory,ABeatSubbandCount,SBeatAtSize,SBeatHistorySize,ABeatHistoryCount);
    SD2Bits_Resize(SBeatAtHistory2,ABeatSubbandCount,ASBeatAtSize,ASBeatHistorySize,ABeatHistoryCount);
    SBeatHistoryCount:=ABeatHistoryCount;
    SIsBeatAt:=SBeatAtHistory;
    SIsBeatAt2:=SBeatAtHistory2;
    SBeatAtPos:=0;
    SBeatAtPos2:=0;
    SBeatCompareCount:=ABeatCompareCount;
    SBeatEqualityCount:=ABeatHistoryCount-ABeatCompareCount;
    FBeatSubbandCount:=ABeatSubbandCount;

    SSubbandSize:=ABeatSubbandCount*SD2BufElemSize;
    SSHSize:=ABeatBufCount*SSubbandSize;

    GetMem(SSubbandHistory,SSHSize);
    GetMem(SAverageSoundEnergys,ABeatSubbandCount*SD2BufElemSize);
    GetMem(SBandWidths,ABeatSubbandCount*SD2IntBufElemSize);
    GetMem(SBeatEquality,SBeatEqualityCount);

    CalcBandWidths;

    ZeroMVFloat(SSubbandHistory,ABeatBufCount*ABeatSubbandCount);
    ZeroMVFloat(SAverageSoundEnergys,ABeatSubbandCount);
  end;
                          {FFSBeatBuffers.SBeatEqualityCount}
  FBPMThread.FBPMList.Size:=Trunc(sqrt(0.25+(2*{FFSBeatBuffers.SBeatEqualityCount}ABeatHistoryCount))-0.5)+1; //berechnet, wie viele Zahlen summiert werden müssen, um auf ABeatHistoryCount zu kommen (so viele verschiedene Beats gibt es maximal)
  FBPMThread.FBPMHistoryList.Size:=FBPMHistoryCount{FBPMList.Size};

  GetMem(FWDatas,FBufsSize);
  GetMem(FLevels,FFBufSize);
  GetMem(FReBuf,FFBufSize);
  GetMem(FImBuf,FFBufSize);
  GetMem(FPeak,FChannels*SD2BufElemSize);

  {GetMem(FBeatBuffer,FBeatBufCount*SD2BeatSize);
  GetMem(FBeatBuffer2,FBeatBufCount*SD2BeatSize);
  GetMem(FBeatBuffer3,FBeatBufCount*SD2BeatSize);
  GetMem(FBeatBuffer4,FBB4Count*SD2BeatSize);}
  GetMem(FSoundHistory,FBeatBufCount*SD2BufElemSize);
  GetMem(FMainBeatBuffer,FBeatBufCount*SD2BufElemSize);

  //GetMem(FBeatBuffers,FBBSSize);

  GetMem(FBPMHistory,FBPMHistoryCount*SD2BufElemSize);
  ZeroMVFloat(FBPMHistory,FBPMHistoryCount);
  //FBPMHistoryList.Clear;

  {FillBeatBuf(FBeatBuffer,FBeatBufCount);
  FillBeatBuf(FBeatBuffer2,FBeatBufCount);
  FillBeatBuf(FBeatBuffer3,FBeatBufCount);
  FillBeatBuf(FBeatBuffer4,FBB4Count);}
  {FillBeatBuf}ZeroMVFloat(FSoundHistory,FBeatBufCount);
  {FillBeatBuf}ZeroMVFloat(FMainBeatBuffer,FBeatBufCount);

  //FillBeatBufs(FBeatBuffers);

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
  SetCounts(Value,FWaveDataCount,FFreqCount,FBufferCount,FBeatBufCount,0{FBB4Count},0{FBeatIterCount},FBeatSubbandCount,FFSBeatBuffers.SBeatHistoryCount,FFSBeatBuffers.SBeatCompareCount,FBPMHistoryCount);
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

procedure TSpectrumData2.SetWaveDataCount(Value: Cardinal);
begin
  FreeMem(FWDatas,FBufsSize);

  FChannelSize:=Value*SD2BufElemSize;
  FBufSize:=FChannelSize*FChannels;
  FBufsSize:=FBufSize*FBufferCount;

  GetMem(FWDatas,FBufsSize);

  FWaveDataCount:=Value;
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
  Result:=FWaveDataCount*FBufferCount;
end;

function TSpectrumData2.GetWaveDataCount: MVInt; stdcall;
begin
  Result:=FWaveDataCount;
end;

function TSpectrumData2.GetLPeakCount: MVInt; stdcall;
begin
  Result:=FLPeakCount;
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
    _Do_(ABufPos^);
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
  Result:=ABuf^[(Channel*FWaveDataCount)+Index];
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
  Result:=ABuf^[((Index div FWaveDataCount)*FBufSize)+(Channel*FChannelSize)+(Index mod FWaveDataCount)];
end;

function TSpectrumData2.GetWaveDataLongB(const Index,Channel,Buffer: MVInt): MVFloat; stdcall;
var
  ABuf: PSD2BufferFormat absolute FWDatas;
begin
  Result:=ABuf^[(Buffer*FBufSize)+(Channel*FChannelSize)+Index];
end;

function TSpectrumData2.GetWaveDataLongC(const Index: MVInt): MVFloat; stdcall;
begin
  Result:=GetWaveDataLongBC(Index mod FWaveDataCount,Index div FWaveDataCount);
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
  BufPos:=FWDatas+(Buffer*FBufSize)+(Index*SD2BufElemSize);
  for I:=0 to FChannels-1 do begin
    _Do_(BufPos^);
    BufPos+=FChannelSize;
  end;
  Result/=FChannels;
end;

function TSpectrumData2.GetPeak(const Channel: MVInt): MVFloat; stdcall;
//var
  //ABuf: PSD2BufferFormat absolute FPeak;
begin
  //Result:=ABuf^[Channel];
  Result:=MVFloat(FPeak^)
end;

function TSpectrumData2.GetBeatBufCount: MVInt; stdcall;
begin
  Result:=FBeatBufCount;
end;

{function TSpectrumData2.GetBeatBuf(const Index: MVInt): TBufferedBeat; stdcall;
var
  ABuf: PSD2BeatBuf absolute FBeatBuffer;
begin
  Result:=ABuf^[(FABeatBuf+Index+1) mod FBeatBufCount];
end;

function TSpectrumData2.GetBeatBuf2(const Index: MVInt): TBufferedBeat; stdcall;
var
  ABuf: PSD2BeatBuf absolute FBeatBuffer2;
begin
  Result:=ABuf^[(FABeatBuf+Index+1) mod FBeatBufCount];
end;

function TSpectrumData2.GetBeatBuf3(const Index: MVInt): TBufferedBeat; stdcall;
var
  ABuf: PSD2BeatBuf absolute FBeatBuffer3;
begin
  Result:=ABuf^[(FBB3Pos.Peak{ABeatBuf}+Index+1) mod FBeatBufCount];
end;

function TSpectrumData2.GetBeatBuf4(const Index: MVInt): TBufferedBeat; stdcall;
var
  ABuf: PSD2BeatBuf absolute FBeatBuffer4;
begin
  Result:=ABuf^[(FBB4Pos.Peak{ABeatBuf}+Index+1) mod FBB4Count];
end;}

function TSpectrumData2.GetSoundHistory(const Index: MVInt): MVFloat; stdcall;
var
  ABuf: PSD2BufferFormat absolute FSoundHistory;
begin
  Result:=ABuf^[(FABeatBuf+Index+1) mod FBeatBufCount];
end;

function TSpectrumData2.GetMainBeatBuffer(const Index: MVInt): MVFloat; stdcall;
var
  ABuf: PSD2BufferFormat absolute FMainBeatBuffer;
begin
  Result:=ABuf^[(FABeatBuf+Index+1) mod FBeatBufCount];
end;

{function TSpectrumData2.GetBeatBufferX(const Buffer,Index: MVInt): TBufferedBeat; stdcall;

  procedure SetResult(const AOffset: Cardinal; out AResult: MVFloat);
  var
    ABuf      : PSD2BufElem;
    ABufHeader: PSD2BeatIndex;
  begin
    ABufHeader:=FBeatBuffers+(AOffset*FSBBSize)+(Buffer*FBBSize);
    ABuf:=Pointer(ABufHeader)+SD2BeatIndexSize+(((ABufHeader^.BHIndex+Index) mod FBB4Count)*SD2BufElemSize);
    AResult:=ABuf^;
  end;

begin
  SetResult(PeakOffset,Result.Peak);
  SetResult(BassOffset,Result.Bass);
  SetResult(BassVocalOffset,Result.BassVocal);
  SetResult(TrebleVocalOffset,Result.TrebleVocal);
  SetResult(TrebleOffset,Result.Treble);
end; }

function TSpectrumData2.GetBeatAt(const Subband,History: MVInt): Boolean; stdcall;
begin
  with FFSBeatBuffers do Result:=SD2Bits_Get(SBeatAtHistory+(SBeatAtSize*((SBeatAtPos+1+History) mod FFSBeatBuffers.SBeatHistoryCount)),Subband);
end;

function TSpectrumData2.GetFSAverage(const Subband: MVInt): MVFloat; stdcall;
var
  ABuf: PSD2BufferFormat absolute FFSBeatBuffers.SAverageSoundEnergys;
begin
  Result:=ABuf^[Subband];
end;

function TSpectrumData2.GetFSHistory(const Index,Subband: MVInt): MVFloat; stdcall;
var
  ABufPointer: Pointer;
  ABuf       : PSD2BufferFormat absolute ABufPointer;
begin
  with FFSBeatBuffers do ABufPointer:=SSubbandHistory+(((FABeatBuf+Index+1) mod FBeatBufCount)*SSubbandSize);
  Result:=ABuf^[Subband];
end;

function TSpectrumData2.GetBeatHistoryCount: MVInt;
begin
  Result:=FFSBeatBuffers.SBeatHistoryCount;
end;

function TSpectrumData2.GetBeatEqualityCount: MVInt;
begin
  Result:=FFSBeatBuffers.SBeatEqualityCount;
end;

function TSpectrumData2.GetBeatEquality(const History: MVInt): MVFloat;
var
  ABufPointer: Pointer;
  ABuf       : PSD2BufferFormat absolute ABufPointer;
begin
  ABufPointer:=FFSBeatBuffers.SBeatEquality;
  Result:=ABuf^[History];
end;

function TSpectrumData2.GetAverageBeatEquality: MVFloat;
begin
  Result:=FFSBeatBuffers.SAverageBeatEquality;
end;

function TSpectrumData2.GetBPMAnalysisTime: MVInt; stdcall;
begin
  Result:=FBPMThread.FFramesNeeded;
end;

{TBPMThread}

constructor TBPMThread.Create(AOwner: TSpectrumData2);
begin
  inherited Create(true);
  FBPMHistoryList:=TUltraSortList.Create;
  FBPMList:=TUltraSortList.Create;
  FSpectrumData:=AOwner;
  FReady:=true;
  FreeOnTerminate:=false;
  FFramesNeeded:=1;
  FFramesUsed:=1;
  Resume;
end;

destructor TBPMThread.Destroy;
begin
  {Terminate;
  WaitFor;}
  FBPMList.Destroy;
  FBPMHistoryList.Destroy;
  inherited Destroy;
end;

procedure TBPMThread.Execute;
begin
  while not Terminated do begin
    if not FReady then begin
      FSpectrumData.DoGetBPM;
      FFramesNeeded:=FFramesUsed;
      FReady:=true;
    end;
  end;
end;

procedure TBPMThread.NextFrame;

  procedure CopyBeatHistory; inline;
  var
    I: Integer;
  begin
    with FSpectrumData.FFSBeatBuffers do begin
      for I:=0 to FFramesUsed-1 do begin
        SBeatAtPos2:=(SBeatAtPos2+1) mod SBeatHistoryCount;
        SD2Bits_Copy(SBeatAtHistory+(SBeatAtSize*SBeatAtPos2),SBeatAtHistory2+(SBeatAtSize*SBeatAtPos2),SBeatAtCount);
      end;
      //if SBeatAtPos2<>SBeatAtPos then ShowMessage('mist');
    end;
  end;

begin
  if FReady then begin
    CopyBeatHistory;
    FFramesUsed:=1;
    FReady:=false;
  end else Inc(FFramesUsed);
end;

{Allgemein}

function ssqr(const X: ValReal): ValReal; inline;
begin
  if X>=0
    then Result:=sqr(X)
    else Result:=-sqr(X);
end;

function cbe(const X: ValReal): ValReal; inline;
begin
  Result:=sqr(X)*X;
end;

function ssqrt(const X: ValReal): ValReal; inline;
begin
  if X>=0
    then Result:=sqrt(X)
    else Result:=-sqrt(-X);
end;

procedure ZeroMVFloat(const Buffer: Pointer; const ACount: Cardinal; const AValue: MVFloat = 0.0); inline;
var
  I   : Integer;
  ABuf: PSD2BufferFormat absolute Buffer;
begin
  for I:=0 to ACount-1 do ABuf^[I]:=AValue;
end;

{function BeatComponent(const Beat: TBufferedBeat; const Component: TBeatTag): MVFloat; inline;
begin
  case Component of
    btPeak       : Result:=Beat.Peak;
    btBass       : Result:=Beat.Bass;
    btBassVocal  : Result:=Beat.BassVocal;
    btTrebleVocal: Result:=Beat.TrebleVocal;
    btTreble     : Result:=Beat.Treble;
  end;
end;}

function SD2Bits_Get(const Bits: PSD2BitBufFormat; const Index: MVInt): Boolean; inline;
begin
  Result:=Boolean((Bits^[Index div SD2BitComponentSizeB] shr (Index mod SD2BitComponentSizeB)) and 1);
end;

procedure SD2Bits_Set(const Bits: PSD2BitBufFormat; const Index: MVInt); inline;
var
  ABuf: PSD2BitBufElem;
begin
  ABuf:=@Bits^[Index div SD2BitComponentSizeB];
  ABuf^:=ABuf^ or (1 shl (Index mod SD2BitComponentSizeB));
end;

procedure SD2Bits_Reset(const Bits: PSD2BitBufFormat; const Size: MVInt); inline;
var
  I: Integer;
begin
  for I:=0 to Size-1 do Bits^[I]:=0;
end;

procedure SD2Bits_Copy(const Source,Dest: PSD2BitBufFormat; const Size: MVInt); inline;
var
  I: Integer;
begin
  for I:=0 to Size-1 do Dest^[I]:=Source^[I];
end;

function SD2Bits_Resize(var Bits: TSD2Bits; const NewSize: MVInt; var ElementSize,OldSize: MVInt; const BufferCount: MVInt = 1): MVInt; inline;
begin
  FreeMem(Bits,OldSize);
  Result:=NewSize div SD2BitComponentSizeB;
  if NewSize mod SD2BitComponentSizeB>0 then Inc(Result);
  ElementSize:=Result*SD2BitComponentSize;
  OldSize:=ElementSize*BufferCount;
  GetMem(Bits,OldSize);
end;

function SD2Bits_Compare(var Bits1,Bits2: PSD2BitBufFormat; const Count,Size: MVInt): MVInt; inline;
var
  I,J,Comb,OverSize: Integer;
begin
  Result:=0;
  for I:=0 to Count-2 do begin
    Comb:=Bits1^[I] and Bits2^[I];
    for J:=0 to SD2BitComponentSizeB-1 do Result+=(Comb shr J) and 1;
  end;
  OverSize:=Size-((Count-1)*SD2BitComponentSizeB);
  Comb:=Bits1^[I] and Bits2^[I];
  for J:=0 to OverSize-1 do Result+=(Comb shr J) and 1;
end;

end.

