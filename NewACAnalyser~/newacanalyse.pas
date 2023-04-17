{ Diese Datei wurde automatisch von Lazarus erzeugt. Sie darf nicht bearbeitet 
  werden!
  Dieser Quelltext dient nur dem Übersetzen und Installieren des Packages.
 }

unit NewACAnalyse; 

interface

uses
  AnaTrans, FreqAna, SpectrumData, UltraSort, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('AnaTrans',@AnaTrans.Register); 
end; 

initialization
  RegisterPackage('NewACAnalyse',@Register); 
end.
