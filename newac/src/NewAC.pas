{ Diese Datei wurde automatisch von Lazarus erzeugt. Sie darf nicht bearbeitet 
  werden!
  Dieser Quelltext dient nur dem Übersetzen und Installieren des Packages.
 }

unit NewAC; 

interface

uses
  ACS_Classes, ACS_Wave, ACS_Vorbis, ACS_Misc, ACS_Converters, ACS_Filters, 
  acs_reg, ACS_AudioMix, VorbisFile, VorbisEnc, Codec, _CDRip, ACS_CDROM, 
  ACS_LAME, lame, ACS_Streams, _MSAcm, WaveConverter, MACDll, ACS_MAC, 
  ACS_Procs, ACS_Types, FLAC, ACS_DXAudio, ACS_FLAC, ACS_smpeg, DSWrapper, 
  _DirectSound, libsamplerate, AuSampleRate, WavPackDLL, ACS_Tags, 
  ACS_WavPack, _DXTypes, ACS_WinMedia, libwma1, wmfintf, ACS_TTA, TTALib, 
  AudioPass, ACS_OptimFROG, OptimFROGDLL, libmpdec, ACS_MPC, ACS_TAK, 
  tak_decoder, libmppenc, AudioDMO, _Direct3D9, _DirectShow9, msdmo, 
  NewAC_AVI, FFTReal, NewAC_DSP, AuASIO, OpenASIO, ASIO, AsioList, mr_cddb, 
  AuSynch, libdca, NewACDTS, NewACAC3, DMXStreams, GainAnalysis, liba52, 
  NewACIndicators, mpg123_, taglib, ogg1, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('acs_reg', @acs_reg.Register); 
end; 

initialization
  RegisterPackage('NewAC', @Register); 
end.
