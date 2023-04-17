unit AdvSpectrum;

{$MODE Delphi}

interface

uses
  Classes, SysUtils, ACS_Types, ACS_Classes, ACS_Procs, SyncObjs, GainAnalysis, LCLIntf, Math, Fourier,
  Forms, SimpleSpectrumData
  {$IFDEF MSWINDOWS}
  ,Windows
  {$ENDIF};

(*{$DEFINE PTS16 }

const
{$IFDEF PTS16}
   Points  = 32;
{$ENDIF}
{$IFDEF PTS32}
   Points  = 64;
{$ENDIF}
   MaxLevel= 15;          *)

const
  Ln2 = Ln(2);

type

  TIndicatorEvent = procedure(Sender : TComponent) of object;

  (* Class: TAdvancedSpectrumIndicator
      This component calculates a rough spectrum of the audio data passing through. It may be used to build a audio visualisation.
      Descends from <TAuConverter>.
   *)

  TOIWaveData                = array of array of Real;

  TOutputIndicator           = class(TAuConverter)
  private
    //FCount : LongWord;
    //FLevels       : array of Real;
    //FShadowLevels : array[0..MaxLevel] of Single;
    //FScaleFactor : Double;
    FInterval     : Cardinal;
    FElapsed      : Cardinal;
    FOnGainData   : TIndicatorEvent;
    //FSampleSize   : Word;
    //FFreqCount    : Cardinal;
    //FSampleBufSize: Integer;
    FFrameCount   : Cardinal;
    //FIFrameCount  : Cardinal;
    //FRBufSize     : Cardinal;
    FWaveData     : TOIWaveData;
    //function GetLevels(Index : Cardinal) : Single;
    //procedure SetFreqCount(Value: Cardinal);
    procedure SetFrameCount(Value: Cardinal);
    function GetWaveData(Index,Channel: Cardinal): Real;
  protected
    procedure GetDataInternal(var Buffer : Pointer; var Bytes : LongWord); override;
    procedure InitInternal; override;
    procedure FlushInternal; override;
    procedure SetInput(aInput : TAuInput); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    (* Property: Levels
      Returns 8 level values for the spectrum. The index value should be in the range of 0-7.
      The levels are logarithmic scale values ranging from -40 (minimum) to 100 (maximum).
      In practice you can consider anything below zero as silence. *)
    //property Levels[Index : Cardinal] : Single read GetLevels;
    property WaveData[Index,Channel: Cardinal]: Real read GetWaveData;
  published
    (* Property: Interval
      Use this property to set the interval (in milliseconds) between two data updates and <OnGainData> events.
      This value sets the minimal interval between updates. The actual interval could be slightly longer depending on the system load. *)
    property FrameCount: Cardinal read FFrameCount write SetFrameCount;
    property Interval : Cardinal read FInterval write FInterval;
    //property FreqCount: Cardinal read FFreqCount write SetFreqCount;
    (* Property: OnGainData
      OnGainData event is called periodically with the period of approximately the <Interval> milliseconds.
      You can use this event to update your GUI spectrum indicators with the current <Levels>.
      The general responsiveness of the GUI indicator depends on the <Interval> and on the system I/O latency.
      For the smooth operation the latency should be set to about of 0.05 second and the <Interval> should be set to about 50.
      See the TDxAudioIn/TDxAudioOut FramesInBuffer and PollingInterval properties for setting the latency under DirectSound. *)
    property OnGainData : TIndicatorEvent read FOnGainData write FOnGainData;
  end;

  TFFTThread                 = class{(TThread)};

  TGetDataEvent              = procedure (var Buffer : Pointer; var Bytes : LongWord) of object;

  TAdvancedSpectrumIndicator = class(TAuConverter)
  private
    //FInterval     : Cardinal;
    //FElapsed      : Real;
    FOnGainData   : TIndicatorEvent;
    //FBytesToRead  : Cardinal;
    //FFreqCount    : Cardinal;
    //FSampleBufSize: Cardinal;
    //FChannels     : Cardinal;
    //FElapseFac    : Real;
    {FWData        : array of Single;
    FReBuf        : TRealArray;
    FImBuf        : TRealArray;}
    //FGetDataProc  : TGetDataEvent;
    FFFTThread    : TFFTThread;
    FEnablePeak   : Boolean;
    function GetLevels(Index : Cardinal) : Real;
    function GetWaveData(Index,Channel: Cardinal): Real; overload;
    function GetWaveData(Index: Cardinal): Real; overload;
    function GetWaveDataLong(Index,Channel,Buffer: Cardinal): Real;  overload;
    function GetWaveDataLong(Index,Channel: Cardinal): Real; overload;
    function GetWaveDataLongC(Index,Buffer: Cardinal): Real; overload;
    function GetWaveDataLongC(Index: Cardinal): Real; overload;
    function GetLongWaveDataCount: Cardinal;
    function GetPeak(Channel: Cardinal): Real; overload;
    function GetFreqCount: Cardinal;
    procedure SetFreqCount(Value: Cardinal);
    procedure SetEnablePeak(Value: Boolean);
    procedure ResetCounts;
    {procedure GetData_FFT(var Buffer : Pointer; var Bytes : LongWord);
    procedure GetData_Drop(var Buffer : Pointer; var Bytes : LongWord);
    procedure GetData_Not(var Buffer : Pointer; var Bytes : LongWord);}
    procedure FFTThreadReady;
    procedure SetBufferCount(Value: Integer);
    function GetBufferCount: Integer;
    function GetInterval: Cardinal;
    procedure SetInterval(Value: Cardinal);
    function GetPriority: TThreadPriority;
    procedure SetPriority(Value: TThreadPriority);
  protected
    procedure GetDataInternal(var Buffer : Pointer; var Bytes : LongWord); override;
    procedure InitInternal; override;
    procedure FlushInternal; override;
    procedure SetInput(aInput : TAuInput); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start;
    (* Property: Levels
      Returns <FreqCount> level values for the spectrum. The index value should be in the range of 0 to <FreqCount>-1.
      The level values range from 0 (minimum) to 1 (maximum).*)
    property Levels[Index : Cardinal]: Real read GetLevels;
    property WaveData[Index,Channel: Cardinal]: Real read GetWaveData;
    property WaveData[Index: Cardinal]: Real read GetWaveData;
    property WaveDataLong[Index,Channel,Buffer: Cardinal]: Real read GetWaveDataLong;
    property WaveDataLong[Index,Channel: Cardinal]: Real read GetWaveDataLong;
    property WaveDataLongC[Index,Buffer: Cardinal]: Real read GetWaveDataLongC;
    property WaveDataLongC[Index: Cardinal]: Real read GetWaveDataLongC;
    property Peak[Channel: Cardinal]: Real read GetPeak;
    property Priority: TThreadPriority read GetPriority write SetPriority;
  published
    property BufferCount: Integer read GetBufferCount write SetBufferCount;
    property EnablePeak: Boolean read FEnablePeak write SetEnablePeak default true;
    property FreqCount: Cardinal read GetFreqCount write SetFreqCount;
    (* Property: Interval
      Use this property to set the interval (in milliseconds) between two data updates and <OnGainData> events.
      This value sets the minimal interval between updates. The actual interval could be slightly longer depending on the system load. *)
    property Interval : Cardinal read GetInterval write SetInterval;
    property LongWaveDataCount: Cardinal read GetLongWaveDataCount;
    property Priority: TThreadPriority read GetPriority write SetPriority;
    (* Property: OnGainData
      OnGainData event is called periodically with the period of approximately the <Interval> milliseconds.
      You can use this event to update your GUI spectrum indicators with the current <Levels>.
      The general responsiveness of the GUI indicator depends on the <Interval> and on the system I/O latency.
      For the smooth operation the latency should be set to about of 0.05 second and the <Interval> should be set to about 50.
      See the TDxAudioIn/TDxAudioOut FramesInBuffer and PollingInterval properties for setting the latency under DirectSound. *)
    property OnGainData : TIndicatorEvent read FOnGainData write FOnGainData;
  end;

  TAdvancedSpectrumData      = class (TSpectrumData)
  private
    FSpectrumIndicator: TAdvancedSpectrumIndicator;
  protected
    function GetLevels(Index : Cardinal) : Real; override;
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
    function GetChannels: Cardinal; override;
  public
    constructor Create(ASpectrumIndicator: TAdvancedSpectrumIndicator);
    procedure AssignSpectrumIndicator(ASpectrumIndicator: TAdvancedSpectrumIndicator);
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
    property Peak[Channel: Cardinal]: Real read GetPeak;
  end;

  TFFTThreadEvent            = procedure of object;

  TASIWData                  = array of Single;
  PASIWData                  = ^TASIWData;
  TBufferPusher              = procedure(var Buffer: Pointer; var Bytes: Cardinal) of object;

  TFFTThread                 = class(TThread)
  private
    FBuffer           : Pointer;
    FBytes            : Cardinal;
    //FSpectrumIndicator: TAdvancedSpectrumIndicator;
    FWDatas       : array of TASIWData;
    FWData        : PASIWData;
    FLevels       : TRealArray;
    FReBuf        : TRealArray;
    FImBuf        : TRealArray;
    FBufferCount  : Integer;
    FABuffer      : Integer;
    FPeak         : TRealArray;
    FSampleSize   : Cardinal;
    FSampleBufSize: Cardinal;
    FBytesToRead  : Cardinal;
    FChannels     : Cardinal;
    FFreqCount    : Cardinal;
    FInterval     : Cardinal;
    FOnReady      : TFFTThreadEvent;
    FGetPeak      : TFFTThreadEvent;
    procedure SetName;
    procedure GetPeak;
    procedure DoNotGetPeak;
  protected
    procedure Execute; override;
    procedure DoPushBuf(var Buffer: Pointer; var Bytes: Cardinal);
    procedure DoNotPushBuf(var Buffer: Pointer; var Bytes: Cardinal);
  public
    PushBuf: TBufferPusher;
    constructor Create(OnReady: TFFTThreadEvent);
    destructor Destroy; override;
    procedure EnablePeak;
    procedure DisablePeak;
    procedure SetBufferCount(ACount: Integer);
  end;

procedure Register;
function Ld(X: Real): Real;

implementation

{TFFTThread}

constructor TFFTThread.Create(OnReady: TFFTThreadEvent);
begin
  inherited Create(true);
  //FSpectrumIndicator:=ASpectrumIndicator;
  FreeOnTerminate:=false;
  FOnReady:=OnReady;
  FGetPeak:=GetPeak;
  FBufferCount:=0;
  FABuffer:=0;
  PushBuf:=DoPushBuf;
  FInterval:=5;
  FBuffer:=nil;
  //Resume;
end;

destructor TFFTThread.Destroy;
var
  I: Integer;
begin
  //Suspend;
  Terminate;
  //Terminated:=true
  WaitFor;
  for I:=0 to FBufferCount-1 do SetLength(FWDatas[I],0);
  SetLength(FWDatas,0);
  inherited Destroy;
end;

procedure TFFTThread.SetBufferCount(ACount: Integer);
var
  I: Integer;
begin
  if ACount<=0 then exit;
  for I:=FBufferCount-1 downto ACount do SetLength(FWDatas[I],0);
  SetLength(FWDatas,ACount);
  for I:=FBufferCount to ACount-1 do SetLength(FWDatas[I],FSampleBufSize);
  FABuffer:=FABuffer mod ACount;
  FWData:=@FWDatas[FABuffer];
  FBufferCount:=ACount;
end;

procedure TFFTThread.EnablePeak;
begin
  SetLength(FPeak,FChannels);
  FGetPeak:=GetPeak;
end;

procedure TFFTThread.DisablePeak;
begin
  SetLength(FPeak,0);
  FGetPeak:=DoNotGetPeak;
end;

procedure TFFTThread.DoPushBuf(var Buffer: Pointer; var Bytes: Cardinal);
begin
  //PushBuf:=DoNotPushBuf;
  FBytes:=Bytes;
  FBuffer:=Buffer;
  if Suspended then Resume;
end;

procedure TFFTThread.DoNotPushBuf(var Buffer: Pointer; var Bytes: Cardinal);
begin

end;

{$IFDEF MSWINDOWS}
type
  TThreadNameInfo = record
    FType: LongWord;     // muss 0x1000 sein
    FName: PChar;        // Zeiger auf Name (in Anwender-Adress-Bereich)
    FThreadID: LongWord; // Thread-ID (-1 ist Caller-Thread)
    FFlags: LongWord;    // Reserviert für spätere Verwendung, muss 0 sein
  end;
{$ENDIF}

procedure TFFTThread.SetName;
{$IFDEF MSWINDOWS}
var
  ThreadNameInfo: TThreadNameInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'FFT';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
{$ENDIF}
end;

procedure TFFTThread.GetPeak;
var
  I,J  : Integer;
  APeak: ^Real;
begin
  //for I:=0 to FFreqCount-1 do
  for I:=0 to FChannels-1 do begin
    APeak:=@FPeak[I];
    APeak^:=0.0;
    J:=I;
    while J<FSampleBufSize do begin
      APeak^+=Abs(FWData[J]);
      Inc(J,FChannels);
    end;
    APeak^/=(FFreqCount*2);
  end;
end;

procedure TFFTThread.DoNotGetPeak;
begin

end;

procedure TFFTThread.Execute;
var
  I,J,IJ: Integer;
  Sign  : Shortint;
begin
  while (FBuffer=nil) and (not Terminated) and (not Application.Terminated) do Sleep(10);
  while (not Terminated) and (not Application.Terminated) do begin
    {while (FBuffer = nil) or (FBytes < FBytesToRead) do begin
      if Terminated or Application.Terminated then exit;
      Sleep(FInterval);
    end;
    PushBuf:=DoNotPushBuf;}
    FABuffer:=(FABuffer+1) mod FBufferCount;
    FWData:=@FWDatas[FABuffer];
    //with FSpectrumIndicator do begin
      //FGetDataProc:=GetData_Drop;
      {FPosition:=FInput.Position;
      FInput.GetData(FBuffer, FBytes);

      FElapsed+=FBytes*FElapseFac;

      if (FBuffer = nil) or (FBytes < FBytesToRead) then goto AExit;}

      //if FElapsed >= FInterval then
      //begin
        //FElapsed := 0.0; //FElapsed - FInterval*100;
        case FSampleSize of
          1 : ByteToSingle(PBuffer8(FBuffer), @FWData^[0], FSampleBufSize);
          2 : SmallIntToSingle(PBuffer16(FBuffer), @FWData^[0], FSampleBufSize);
          3 : Int24ToSingle(PBuffer8(FBuffer), @FWData^[0], FSampleBufSize);
          4 : Int32ToSingle(PBuffer32(FBuffer), @FWData^[0], FSampleBufSize);
        end;
      {FBuffer:=nil;
      PushBuf:=DoPushBuf};

        IJ:=0;
        for I:=0 to FFreqCount-1 do begin
          FReBuf[I]:=0.0;
          for J:=0 to FChannels-1 do begin
            FReBuf[I]+=FWData^[IJ];
            Inc(IJ);
          end;
          FReBuf[I]/=FChannels;
          FImBuf[I]:=0.0;
        end;
        Sign:=1;

        FFT(FReBuf,FImBuf,FFreqCount,Sign);
        for I:=0 to FFreqCount-1 do FLevels[I]:=Sqrt(Sqr(FReBuf[I])+Sqr(FImBuf[I]));
        {Synchronize(}{FOnReady}{)};
        //if Assigned(FOnGainData) then EventHandler.PostGenericEvent(FSpectrumIndicator, FOnGainData);
      //end;
      //AExit:
      //FGetDataProc:=GetData_FFT;
    //end;
    FGetPeak;

    //FOnReady;
    //PushBuf:=DoPushBuf;
    //FBuffer:=nil;
    //Sleep(10);
    //if Application.Terminated then Terminate;


    //Suspend;
  end;
end;

{TAdvancedSpectrumIndicator}

constructor TAdvancedSpectrumIndicator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFFTThread:=TFFTThread.Create(FFTThreadReady);
  //FInterval := 40;
  FFFTThread.FFreqCount:= 512;
  SetLength(FFFTThread.FLevels,FFFTThread.FFreqCount);
  //FGetDataProc:=GetData_FFT;
  //FGetDataProc:=GetData_Not;
  FEnablePeak:=true;
  FFFTThread.SetBufferCount(1);
  //FFFTThread.Resume;
end;

destructor TAdvancedSpectrumIndicator.Destroy;
begin
  FFFTThread.Terminate;
  FFFTThread.WaitFor;
  FOnGainData:=nil;
  SetLength(FFFTThread.FLevels,0);
  (***)
  //FFTThread.SetBufferCount(0);
  SetLength(FFFTThread.FReBuf,0);
  SetLength(FFFTThread.FImBuf,0);
  FFFTThread.Destroy;
  inherited Destroy;
end;

procedure TAdvancedSpectrumIndicator.InitInternal;
var
  i : Integer;
begin
  //FGetDataProc:=GetData_Not;
  Busy := True;
  FPosition := 0;
  FInput.Init;
  ResetCounts;
  FSize := FInput.Size;
  FPosition := 0;
end;

procedure TAdvancedSpectrumIndicator.ResetCounts;
var
  I: Integer;
begin
  if FInput<>nil then begin
    FSampleSize := FInput.BitsPerSample div 8;
    FFFTThread.FSampleSize:=FSampleSize;
    with FFFTThread do begin
      FChannels:=FInput.Channels;
      FSampleBufSize:=FFreqCount*FChannels;
      FBytesToRead:=FSampleSize*FSampleBufSize;
      //FElapseFac:=1000{00}/(FSampleSize*FFFTThread.FChannels*FInput.SampleRate);
      //SetLength(FWDatas,FBufferCount); (***)
      for I:=0 to FBufferCount-1 do SetLength(FWDatas[I],FSampleBufSize);
      //FWData:=@FWDatas[FABuffer];
      //SetLength(FWData,FSampleBufSize);
      SetLength(FReBuf,FFreqCount);
      SetLength(FImBuf,FFreqCount);
      if FEnablePeak then SetLength(FPeak,FChannels);
    end;
  end;
  with FFFTThread do begin
    SetLength(FLevels,0);
    SetLength(FLevels,FFreqCount);
  end;
end;

procedure TAdvancedSpectrumIndicator.GetDataInternal(var Buffer: Pointer; var Bytes: Cardinal);
begin
  //FGetDataProc:=GetData_Drop;
  //FFFTThread.PushBuf(Buffer,Bytes);
  //FGetDataProc:=GetData_Drop;
  FPosition:=FInput.Position;
  FInput.GetData(Buffer, Bytes);

  //FElapsed+=Bytes*FElapseFac;

  //if (Buffer = nil) or (Bytes < FBytesToRead) then goto AExit;
//  if (Buffer <> nil) and (Bytes >= FBytesToRead) {or (FElapsed<FInterval)} then {FGetDataProc:=GetData_FFT else begin}
    //FElapsed:=0.0;
    FFFTThread.PushBuf(Buffer,Bytes);
  //end;
  //FGetDataProc(Buffer,Bytes);
end;

(*procedure TAdvancedSpectrumIndicator.GetData_Drop(var Buffer: Pointer; var Bytes: Cardinal);
begin
  FInput.GetData(Buffer, Bytes);
//  FElapsed+=Bytes*FElapseFac;
end;*)

(*procedure TAdvancedSpectrumIndicator.GetData_FFT(var Buffer: Pointer; var Bytes: Cardinal);
{var
  I,J,IJ: Integer;
  Sign  : Shortint;
label
  AExit;}
begin
  FGetDataProc:=GetData_Drop;
  //FFFTThread.PushBuf(Buffer,Bytes);
  //FGetDataProc:=GetData_Drop;
  FPosition:=FInput.Position;
  FInput.GetData(Buffer, Bytes);

//  FElapsed+=Bytes*FElapseFac;

  //if (Buffer = nil) or (Bytes < FBytesToRead) then goto AExit;
{  if (Buffer = nil) or (Bytes < FBytesToRead) or (FElapsed<FInterval) then FGetDataProc:=GetData_FFT else begin
    FElapsed:=0.0;
    FFFTThread.PushBuf(Buffer,Bytes);
  end;}

  {if FElapsed >= FInterval then
  begin
    FElapsed := 0.0; //FElapsed - FInterval*100;
    case FSampleSize of
      1 : ByteToSingle(PBuffer8(Buffer), @FWData[0], FSampleBufSize);
      2 : SmallIntToSingle(PBuffer16(Buffer), @FWData[0], FSampleBufSize);
      3 : Int24ToSingle(PBuffer8(Buffer), @FWData[0], FSampleBufSize);
      4 : Int32ToSingle(PBuffer32(Buffer), @FWData[0], FSampleBufSize);
    end;
    //FFFTThread.PushBuf;
    //exit;
    IJ:=0;
    for I:=0 to FFreqCount-1 do begin
      FReBuf[I]:=0.0;
      for J:=0 to FChannels-1 do begin
        FReBuf[I]+=FWData[IJ];
        Inc(IJ);
      end;
      FReBuf[I]/=FChannels;
      FImBuf[I]:=0.0;
    end;
    Sign:=1;

    FFT(FReBuf,FImBuf,FFreqCount,Sign);
    for I:=0 to FFreqCount-1 do FLevels[I]:=Sqrt(Sqr(FReBuf[I])+Sqr(FImBuf[I]));

    if Assigned(FOnGainData) then EventHandler.PostGenericEvent(Self, FOnGainData);
  end;
  AExit:
  FGetDataProc:=GetData_FFT;}
end;*)

(*procedure TAdvancedSpectrumIndicator.GetData_Not(var Buffer: Pointer; var Bytes: Cardinal);
begin
  //FInput.GetData(Buffer, Bytes);
  //FElapsed+=Bytes*FElapseFac;
  Buffer:=nil;
  Bytes:=0;
end;*)

procedure TAdvancedSpectrumIndicator.Start;
begin
  //FGetDataProc:=GetData_FFT;
end;

procedure TAdvancedSpectrumIndicator.FFTThreadReady;
begin
  if Assigned(FOnGainData) then EventHandler.PostGenericEvent(Self, FOnGainData);
  //FGetDataProc:=GetData_FFT;
end;

procedure TAdvancedSpectrumIndicator.SetBufferCount(Value: Integer);
begin
  FFFTThread.SetBufferCount(Value);
end;

function TAdvancedSpectrumIndicator.GetBufferCount: Integer;
begin
  Result:=FFFTThread.FBufferCount;
end;

function TAdvancedSpectrumIndicator.GetInterval: Cardinal;
begin
  Result:=FFFTThread.FInterval;
end;

procedure TAdvancedSpectrumIndicator.SetInterval(Value: Cardinal);
begin
  FFFTThread.FInterval:=Value;
end;

function TAdvancedSpectrumIndicator.GetPriority: TThreadPriority;
begin
  Result:=FFFTThread.Priority;
end;

procedure TAdvancedSpectrumIndicator.SetPriority(Value: TThreadPriority);
begin
  FFFTThread.Priority:=Value;
end;

procedure TAdvancedSpectrumIndicator.FlushInternal;
begin
  FInput.Flush;
  Busy := False;
end;

procedure TAdvancedSpectrumIndicator.SetInput(aInput : TAuInput);
begin
  inherited SetInput(aInput);
end;

procedure TAdvancedSpectrumIndicator.SetFreqCount(Value: Cardinal);
begin
  FFFTThread.FFreqCount:=Trunc(IntPower(2,Trunc(Ld(Value))));
  ResetCounts;
end;

procedure TAdvancedSpectrumIndicator.SetEnablePeak(Value: Boolean);
begin
  FEnablePeak:=Value;
  if Value
    then FFFTThread.EnablePeak
    else FFFTThread.DisablePeak;
end;

function TAdvancedSpectrumIndicator.GetFreqCount: Cardinal;
begin
  Result:=FFFTThread.FFreqCount;
end;

function TAdvancedSpectrumIndicator.GetLevels(Index: Cardinal) : Real;
begin
  if (Index>FFFTThread.FFreqCount) or (Index<0) then
    Result := 0
  else
    Result := FFFTThread.FLevels[Index];
end;

function TAdvancedSpectrumIndicator.GetWaveData(Index,Channel: Cardinal): Real; overload;
begin
  with FFFTThread do Result:=FWData[(Index*FChannels)+Channel];
end;

function TAdvancedSpectrumIndicator.GetWaveData(Index: Cardinal): Real; overload;
var
  I,II: Integer;
begin
  Result:=0.0;
  with FFFTThread do begin
    II:=Index*FChannels;
    for I:=1 to FChannels do begin
      Result+=FWData[II];
      Inc(II);
    end;
    Result/=FChannels;
  end;
end;

function TAdvancedSpectrumIndicator.GetWaveDataLong(Index,Channel,Buffer: Cardinal): Real;
begin
  with FFFTThread do Result:=FWDatas[Buffer][(Index*FChannels)+Channel];
end;

function TAdvancedSpectrumIndicator.GetWaveDataLong(Index,Channel: Cardinal): Real;
begin
  Result:=0.0;
end;

function TAdvancedSpectrumIndicator.GetWaveDataLongC(Index,Buffer: Cardinal): Real;
var
  I,II: Integer;
begin
  Result:=0.0;
  with FFFTThread do begin
    II:=Index*FChannels;
    for I:=1 to FChannels do begin
      Result+=FWDatas[Buffer][II];
      Inc(II);
    end;
    Result/=FChannels;
  end;
end;

function TAdvancedSpectrumIndicator.GetLongWaveDataCount: Cardinal;
begin
  with FFFTThread do Result:=FFreqCount*FBufferCount;
end;

function TAdvancedSpectrumIndicator.GetWaveDataLongC(Index: Cardinal): Real;
var
  I,II,BufIndex: Integer;
begin
  Result:=0.0;
  BufIndex:=((Index+FFFTThread.FABuffer) div FFFTThread.FFreqCount) mod FFFTThread.FBufferCount;
  with FFFTThread do begin
    II:=(Index mod FFFTThread.FFreqCount)*FChannels;
    for I:=1 to FChannels do begin
      Result+=FWDatas[BufIndex][II];
      Inc(II);
    end;
    Result/=FChannels;
  end;
end;

function TAdvancedSpectrumIndicator.GetPeak(Channel: Cardinal): Real; overload;
begin
  Result:=FFFTThread.FPeak[Channel];
end;

{TOutputIndicator}

constructor TOutputIndicator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInterval := 40;
  FFrameCount:=0;
  //FIFrameCount:=0;
  //FBufSize:=0;
  //FRBufSize:=0;
  //SetBufSize(2048);
  //FFreqCount:=512;
  //SetLength(FLevels,FFreqCount);
end;

destructor TOutputIndicator.Destroy;
begin
  FOnGainData:=nil;
  //FFreqCount:=0;
  //SetLength(FLevels,0);
  FFrameCount:=0;
  SetLength(FWaveData,0);
  inherited Destroy;
end;

procedure TOutputIndicator.InitInternal;
//var
//  I,J,Ch: Integer;
begin
  Busy := True;
  FPosition := 0;
  FInput.Init;
  FSampleSize := FInput.BitsPerSample div 8;
  //FillChar(FWaveData,SizeOf(FWaveData),#0);
  {Ch:=FInput.Channels-1;
  for I:=0 to FFrameCount-1
    do for J:=0 to Ch
      do FWaveData[I][J]:=0;}

  //FCount := 0;
  //for i := 0 to MaxLevel do Flevels[i] := 0;
  //SetLength(FLevels,0);
  //SetLength(FLevels,FFreqCount);
  //I:=FBufSize;
  //SetBufSize(0);
  //SetLength(FWaveData,0);
  //SetBufSize(FFrameCount);
  //ZeroMemory(
  //SetBufSize(2048);
  FSize := FInput.Size;
  FPosition := 0;
end;

procedure TOutputIndicator.GetDataInternal(var Buffer: Pointer; var Bytes: Cardinal);
//const
//  SamplesInBuf = 1536;
var
  SamplesInBuf : Integer{= 1536};
  i, j, Ch: Integer;
  SamplesRead, FramesRead: LongWord;
  InBuf   : array{[0..SamplesInBuf-1]} of Single;
  ABytes  : Integer;
  //InReBuf : TRealArray;
  //InImBuf : TRealArray;
  //Sign    : Shortint;

  //OutFloatBuf : array[0..SamplesInBuf-1] of Single;
  //YFloatBuf : array[0..SamplesInBuf-1] of Single;
  //InCmplx : array[0..Points-1] of TComplexSingle;
  //CW : LongWord;
begin
  //exit;
  {if Input=nil then begin
    Bytes:=0;
    Buffer:=nil;
    exit;
  end;}
  //FInput.GetData(Buffer,Bytes);
  //exit;
  //if not Busy then exit;
  SamplesInBuf:=FFrameCount*FInput.Channels;
  SetLength(InBuf,SamplesInBuf);
  FPosition := FInput.Position;
  ABytes:=FSampleSize*SamplesInBuf;
  //if Bytes > FSampleSize*SamplesInBuf then Bytes := FSampleSize*SamplesInBuf;
  FInput.GetData(Buffer, Bytes);
  if (Buffer = nil) or (Bytes <ABytes) then
    Exit;
  SamplesRead := ABytes div FSampleSize;
  case FSampleSize of
    1 : ByteToSingle(PBuffer8(Buffer), @InBuf[0], SamplesRead);
    2 : SmallIntToSingle(PBuffer16(Buffer), @InBuf[0], SamplesRead);
    3 : Int24ToSingle(PBuffer8(Buffer), @InBuf[0], SamplesRead);
    4 : Int32ToSingle(PBuffer32(Buffer), @InBuf[0], SamplesRead);
  end;
  FramesRead := SamplesRead div FInput.Channels;
  Ch := FInput.Channels;

  for I:=0 to FFrameCount-1 do begin
    for J:=0 to Ch-1 do begin
      FWaveData[I][J]:=InBuf[(I*Ch)+J];
    end;

    //FWaveData[I]:=0;

    (*for J:=0 to FInput.Channels do begin
      FWaveData[I]+=InBuf[(I*FInput.Channels)+J];
    end;*)
    //FWaveData[I]/=FInput.Channels;
  end;





  //CW := 0;
  (*SetSingleFPUPrecision(@CW);
  for i := 0 to FramesRead - 1 do
  begin
    OutFloatBuf[i] := 0;
    for j := 0 to Ch - 1 do
      OutFloatBuf[i] := OutFloatBuf[i] + InFloatBuf[Ch*i +j];
    OutFloatBuf[i] := OutFloatBuf[i]/Ch;
  end;
  YFloatBuf[0] := OutFloatBuf[0];
  for i := 1 to FramesRead - 1 do
  YFloatBuf[i] := 0.9*(YFloatBuf[i-1] + OutFloatBuf[i] - OutFloatBuf[i-1]);

  for i := 0 to (FramesRead div Points) - 1 do
  begin
    for j := 0 to Points-1 do
    begin
      InCmplx[j].Re := YFloatBuf[i*Points + j];
      InCmplx[j].Im := 0;
    end;
//    try
    ComplexFFTSingle(@InCmplx, Points, 1);
    Inc(FCount);
//    except
//      Exit;
//    end;
    if Points = 16 then
{$IFDEF PTS16}
    for j := 0 to MaxLevel do
       FShadowLevels[j] := FShadowLevels[j] + Sqrt(Sqr(InCmplx[j].Re) + Sqr(InCmplx[j].Im))
 {$ENDIF}
 {$IFDEF PTS32}
    for j := 0 to MaxLevel do
       FShadowLevels[j] := FShadowLevels[j] + (Sqrt(Sqr(InCmplx[j*2].Re) + Sqr(InCmplx[j*2].Im)) + Sqrt(Sqr(InCmplx[j*2+1].Re) + Sqr(InCmplx[j*2+1].Im)));
 {$ENDIF}
  end;
  RestoreCW(@CW);*)
  (*FElapsed := FElapsed + Round(FramesRead/FInput.SampleRate*100000);
  if FElapsed >= FInterval*100 then
  begin
    FElapsed := 0; //FElapsed - FInterval*100;

    SetLength(InImBuf,FFreqCount);
    SetLength(InReBuf,FFreqCount);
    for I:=0 to FFreqCount-1 do begin
      InREBuf[I]:=0;
      for J:=0 to FInput.Channels-1 do InReBuf[I]+=InBuf[I+J];
      InReBuf[I]/=FInput.Channels;
      InImBuf[I]:=0;
    end;
    Sign:=1;
    FFT(InREBuf,InImBuf,FFreqCount,Sign);
    for I:=0 to FFreqCount-1 do Flevels[I]:=Sqrt(Sqr(InReBuf[I])+Sqr(InImBuf[I]));*)


    (*if FCount <> 0 then

    for j := 0 to MaxLevel do
    begin
       FLevels[j] := (Log10(0.125*FShadowLevels[j]/(FCount)*Sin((j+0.5)*Pi/16) + 1e-4)+3)*40;
       FShadowLevels[j] := 0;
    end;
    FCount := 0;*)
  (*  if Assigned(FOnGainData) then
      EventHandler.PostGenericEvent(Self, FOnGainData);
  end;
  SetLength(InBuf,0);*)
end;

procedure TOutputIndicator.FlushInternal;
begin
  FInput.Flush;
  Busy := False;
end;

procedure TOutputIndicator.SetInput(aInput : TAuInput);
var
  I,Ch: Integer;
begin
  inherited SetInput(aInput);
  //if Input<>nil then begin
    //Ch:=FInput.Channels;
    //FIFrameCount:=FFrameCount;
    //SetLength(FWaveData,FIFrameCount);
    //for I:=0 to FFrameCount-1 do SetLength(FWaveData[I],Ch);
  //end else begin
    //Ch:=0;
    //FIFrameCount:=0;
    //FFrameCount:=0;
    //SetLength(FWaveData,0);
  //end;
  //SetBufSize(FBufSize);
  //FSampleBufSize:=
end;

//procedure TOutputIndicator.SetFreqCount(Value: Cardinal);
//begin
  //FFreqCount:=Trunc(IntPower(2,Trunc(Ld(Value))));
  (*SetLength(FLevels,0);
  SetLength(FLevels,FFreqCount);*)
//end;

procedure TOutputIndicator.SetFrameCount(Value: Cardinal);
var
  I: Integer;
begin
  //FFrameCount:=Value;
  {if FInput=nil then begin
    FFrameCount:=0;
    SetLength(FWaveData,0);
    //FIFrameCount:=0;
    //FFrameCount:=Value;
//    FRBufSize:=0;
    exit;
  end;}
  SetLength(FWaveData,Value);
  for I:=FFrameCount to Value-1 do SetLength(FWaveData[I],FInput.Channels);
  FFrameCount:=Value;
  //FIFrameCount:=Value;
//  FRBufSize:=Value;
end;

function TOutputIndicator.GetWaveData(Index,Channel: Cardinal): Real;
begin
  //Result:=0;
  Result:=FWaveData[Index][Channel];
end;

(*function TOutputIndicator.GetLevels(Index: Cardinal) : Single;
begin
  if Index>FFreqCount then
    Result := 0
  else
    Result := FLevels[Index];
end;*)

{TAdvancedSpectrumData}

constructor TAdvancedSpectrumData.Create(ASpectrumIndicator: TAdvancedSpectrumIndicator);
begin
  inherited Create;
  FSpectrumIndicator:=ASpectrumIndicator;
end;

procedure TAdvancedSpectrumData.AssignSpectrumIndicator(ASpectrumIndicator: TAdvancedSpectrumIndicator);
begin
  FSpectrumIndicator:=ASpectrumIndicator;
end;

function TAdvancedSpectrumData.GetLevels(Index : Cardinal) : Real;
begin
  Result:=FSpectrumIndicator.FFFTThread.FLevels[Index];
end;

function TAdvancedSpectrumData.GetWaveData(Index,Channel: Cardinal): Real;
begin
  Result:=FSpectrumIndicator.GetWaveData(Index,Channel);
end;

function TAdvancedSpectrumData.GetWaveData(Index: Cardinal): Real;
begin
  Result:=FSpectrumIndicator.GetWaveData(Index);
end;

function TAdvancedSpectrumData.GetWaveDataLong(Index,Channel,Buffer: Cardinal): Real;
begin
  Result:=FSpectrumIndicator.GetWaveDataLong(Index,Channel,Buffer);
end;

function TAdvancedSpectrumData.GetWaveDataLong(Index,Channel: Cardinal): Real;
begin
  Result:=FSpectrumIndicator.GetWaveDataLong(Index,Channel);
end;

function TAdvancedSpectrumData.GetWaveDataLongC(Index,Buffer: Cardinal): Real;
begin
  Result:=FSpectrumIndicator.GetWaveDataLongC(Index,Buffer);
end;

function TAdvancedSpectrumData.GetWaveDataLongC(Index: Cardinal): Real;
begin
  Result:=FSpectrumIndicator.GetWaveDataLongC(Index);
end;

function TAdvancedSpectrumData.GetLongWaveDataCount: Cardinal;
begin
  Result:=FSpectrumIndicator.LongWaveDataCount;
end;

function TAdvancedSpectrumData.GetPeak(Channel: Cardinal): Real;
begin
  Result:=FSpectrumindicator.FFFTThread.FPeak[Channel];
end;

function TAdvancedSpectrumData.GetFreqCount: Cardinal;
begin
  Result:=FspectrumIndicator.FFFTThread.FFreqCount;
end;

function TAdvancedSpectrumData.GetBufferCount: Integer;
begin
  Result:=FSpectrumIndicator.FFFTThread.FBufferCount;
end;

function TAdvancedSpectrumData.GetChannels: Cardinal;
begin
  Result:=FSpectrumIndicator.FFFTThread.FChannels;
end;

{Allgemein}

procedure Register;
begin
  RegisterComponents('Audio Additions',[TAdvancedSpectrumIndicator,TOutputIndicator]);
end;

function Ld(X: Real): Real;
begin
  Result:=Ln(X)/Ln2;
end;

end.
