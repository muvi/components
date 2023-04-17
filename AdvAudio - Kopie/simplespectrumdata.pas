unit SimpleSpectrumData;

{$MODE Delphi}

interface

uses
  Classes, SysUtils;

type
  TSpectrumData= class
  protected
    function GetLevels(Index : Cardinal) : Real; virtual; abstract;
    function GetWaveData(Index,Channel: Cardinal): Real; overload; virtual; abstract;
    function GetWaveData(Index: Cardinal): Real; overload; virtual; abstract;
    function GetWaveDataLong(Index,Channel,Buffer: Cardinal): Real;  overload; virtual; abstract;
    function GetWaveDataLong(Index,Channel: Cardinal): Real; overload; virtual; abstract;
    function GetWaveDataLongC(Index,Buffer: Cardinal): Real; overload; virtual; abstract;
    function GetWaveDataLongC(Index: Cardinal): Real; overload; virtual; abstract;
    function GetLongWaveDataCount: Cardinal; virtual; abstract;
    function GetPeak(Channel: Cardinal): Real; overload; virtual; abstract;
    function GetFreqCount: Cardinal; virtual; abstract;
    function GetBufferCount: Integer; virtual; abstract;
    function GetChannels: Cardinal; virtual; abstract;
  public
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

implementation

end.

