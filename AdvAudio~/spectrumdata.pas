unit SpectrumData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  MVFloat        = Single;
  MVInt          = LongWord;
  TFFTMode       = (fftCombined,fftAllChannels,fftFirst);
  TSDAnalyseFlag = (afFFT,afPeak);
  TSDAnalyseMode = set of TSDAnalyseFlag;
  ISpectrumData  = interface (IInterface)
    ['{82072229-15A0-4B67-95A0-105C8C42DFFC}']
    //['{57D14611-020A-42B5-827F-B485BCB28CAD}']
    function GetChannels: MVInt; stdcall;
    function GetBufferCount: MVInt; stdcall;
    function GetFreqCount: MVInt; stdcall;
    function GetLongWaveDataCount: MVInt; stdcall;
    function GetSampleCount: MVInt; stdcall;
    function GetSampleRate: MVInt; stdcall;

    function GetFFTMode: TFFTMode; stdcall;
    function GetAnalyseMode: TSDAnalyseMode; stdcall;

    function GetLevels(const Index,Channel: MVInt): MVFloat; stdcall;
    function GetLevelsC(const Index: MVInt): MVFloat; stdcall;
    function GetWaveData(const Index,Channel: MVInt): MVFloat; stdcall;
    function GetWaveDataC(const Index: MVInt): MVFloat; stdcall;
    function GetWaveDataLong(const Index,Channel: MVInt): MVFloat; stdcall;
    function GetWaveDataLongB(const Index,Channel,Buffer: MVInt): MVFloat; stdcall;
    function GetWaveDataLongC(const Index: MVInt): MVFloat; stdcall;
    function GetWaveDataLongBC(const Index,Buffer: MVInt): MVFloat; stdcall;
    function GetPeak(const Channel: MVInt): MVFloat; stdcall;

    property Channels: MVInt read GetChannels;
    property BufferCount: MVInt read GetBufferCount;
    property FreqCount: MVInt read GetFreqCount;
    property LongWaveDataCount: MVInt read GetLongWaveDataCount;
    property SampleCount: MVInt read GetSampleCount;
    property SampleRate: MVInt read GetSampleRate;

    property FFTMode: TFFTMode read GetFFTMode;
    property AnalyseMode: TSDAnalyseMode read GetAnalyseMode;

    property Levels[Index,Channel: MVInt]: MVFloat read GetLevels; default;
    property LevelsC[Index: MVInt]: MVFloat read GetLevelsC;
    property WaveData[Index,Channel: MVInt]: MVFloat read GetWaveData;
    property WaveDataC[Index: MVInt]: MVFloat read GetWaveDataC;
    property WaveDataLong[Index,Channel: MVInt]: MVFloat read GetWaveDataLong;
    property WaveDataLongB[Index,Channel,Buffer: MVInt]: MVFloat read GetWaveDataLongB;
    property WaveDataLongC[Index: MVInt]: MVFloat read GetWaveDataLongC;
    property WaveDataLongBC[Index,Buffer: MVInt]: MVFloat read GetWaveDataLongBC;
    property Peak[Channel: MVInt]: MVFloat read GetPeak;
  end;

const
  IIDSpectrumData: TGUID = '{82072229-15A0-4B67-95A0-105C8C42DFFC}';//'{57D14611-020A-42B5-827F-B485BCB28CAD}';

implementation

end.

