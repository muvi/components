unit AnaTrans;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, NewAC, ACS_Types, ACS_Classes, ACS_Procs, FreqAna, Dialogs,
  Forms;

type
  TNACAnalyseTransmitter = class;

  //DX-Hack; beschleunigt den Input enorm.
  TNACHackFFTThread      = class (TThread)
  protected
    FSpectrumData: TSpectrumData2;
    FInBufSize   : Cardinal;
    FBuffer      : Pointer;
    FWaitTime    : Integer;
    //FSampleSize  : Integer;
    FNACAT       : TNACAnalyseTransmitter;
    procedure Execute; override;
    procedure ConvertBuf(var InBuf,OutBuf: Pointer); inline;
  public
    constructor Create(const NACAT: TNACAnalyseTransmitter);
    destructor Destroy; override;
  published
    property WaitTime: Integer read FWaitTime write FWaitTime;
  end;

  TNACAnalyseTransmitter = class (TAuConverter)
  private
    //FFFTThread: TNACHackFFTThread;
    FSpectrumData: TSpectrumData2;
    FInBufSize   : Cardinal;
  protected
    procedure GetDataInternal(var Buffer : Pointer; var Bytes : LongWord); override;
    procedure InitInternal; override;
    procedure FlushInternal; override;
    procedure SetInput(aInput : TAuInput); override;
    procedure ResetCounts; inline;
    procedure ConvertBuf(var InBuf,OutBuf: Pointer); inline;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AssignSpectrumData(ASpectrumData: TSpectrumData2);
  end;

procedure Register;

implementation

{TNACHackFFTThread}

constructor TNACHackFFTThread.Create(const NACAT: TNACAnalyseTransmitter);
begin
  inherited Create(true);
  FreeOnTerminate:=true;
  FNACAT:=NACAT;
  FWaitTime:=5;
end;

destructor TNACHackFFTThread.Destroy;
begin
  //Terminate;
  //WaitFor;
  inherited Destroy;
end;

procedure TNACHackFFTThread.ConvertBuf(var InBuf,OutBuf: Pointer); inline;
begin
  case FNACAT.FSampleSize of
    1 : ByteToSingle(PBuffer8(InBuf), OutBuf, FInBufSize);
    2 : SmallIntToSingle(PBuffer16(InBuf), OutBuf, FInBufSize);
    3 : Int24ToSingle(PBuffer8( InBuf), OutBuf, FInBufSize);
    4 : Int32ToSingle(PBuffer32(InBuf), OutBuf, FInBufSize);
  end;
end;

procedure TNACHackFFTThread.Execute;
begin
  while (not Terminated) and (not Application.Terminated) do begin
    ConvertBuf(FBuffer,FSpectrumData.FWData);
    FSpectrumData.Analyse;
    //Sleep(FWaitTime);
  end;
end;

{TNACAnalyseTransmitter}

constructor TNACAnalyseTransmitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //FFFTThread:=TNACHackFFTThread.Create(Self);
end;

destructor TNACAnalyseTransmitter.Destroy;
begin
  //FFFTThread.Terminate;
  //FFFTThread.WaitFor;
  //FFFTThread.Terminate;
  //FFFTThread.Destroy;
  inherited Destroy;
end;

procedure TNACAnalyseTransmitter.ResetCounts;
begin
  FSampleSize:=FInput.BitsPerSample div 8;
  //FChannels:=FInput.Channels;
  {with FFFTThread do} with FSpectrumData
    do FInBufSize:=FSampleSize*Channels*WaveDataCount;
end;

procedure TNACAnalyseTransmitter.AssignSpectrumData(ASpectrumData: TSpectrumData2);
//var
  //Temp: Integer;
begin
  {FFFTThread.}FSpectrumData:=ASpectrumData;
  //temp:=FInput.BitsPerSample;
  //InBufSize:=Self.FInput.
  //FSpectrumData.SetCounts();
end;

procedure TNACAnalyseTransmitter.ConvertBuf(var InBuf,OutBuf: Pointer); inline;
begin
  case {FNACAT.}FSampleSize of
    1 : ByteToSingle(PBuffer8(InBuf), OutBuf, FInBufSize);
    2 : SmallIntToSingle(PBuffer16(InBuf), OutBuf, FInBufSize);
    3 : Int24ToSingle(PBuffer8( InBuf), OutBuf, FInBufSize);
    4 : Int32ToSingle(PBuffer32(InBuf), OutBuf, FInBufSize);
  end;
end;

procedure TNACAnalyseTransmitter.GetDataInternal(var Buffer : Pointer; var Bytes : LongWord);
begin
  //Bytes:=FInBufSize{FSpectrumData.SampleCount*FSampleSize*FSpectrumData.Channels};
  Bytes:=1024;
  FInput.GetData(Buffer,Bytes);
  {FFFTThread.FBuffer:=Buffer;
  if FFFTThread.Suspended then begin
    //FFFTThread.FSampleSize:=FSampleSize;
    FFFTThread.Resume;
  end;}
  ConvertBuf(Buffer,FSpectrumData.FWData);
  FSpectrumData.Analyse;
  //ShowMessage(intToStr(Bytes));
  //if Bytes<FInBufSize then exit;
  //ConvertBuf(Buffer,FSpectrumData.FWData);
  //FSpectrumData.Analyse;
end;

procedure TNACAnalyseTransmitter.InitInternal;
begin
  //inherited InitInternal;
  Busy := True;
  FPosition := 0;
  FInput.Init;
  ResetCounts;
  FSize := FInput.Size;
  {FFFTThread.}FSpectrumData.SampleRate:=FInput.SampleRate;
  FPosition := 0;
end;

procedure TNACAnalyseTransmitter.FlushInternal;
begin
  //FFFTThread.Suspend;
  FInput.Flush;
end;

procedure TNACAnalyseTransmitter.SetInput(aInput : TAuInput);
begin
  inherited SetInput(aInput);
end;

{Allgemein}

procedure Register;
begin
  RegisterComponents('Audio Additions',[TNACAnalyseTransmitter]);
end;

end.

