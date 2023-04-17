{ Diese Datei wurde automatisch von Lazarus erzeugt. Sie darf nicht bearbeitet 
  werden!
  Dieser Quelltext dient nur dem Übersetzen und Installieren des Packages.
 }

unit AdvAudio; 

interface

uses
AdvSpectrum, FOURIER, SimpleSpectrumData, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('AdvSpectrum', @AdvSpectrum.Register); 
end; 

initialization
  RegisterPackage('AdvAudio', @Register); 
end.
