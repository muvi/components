{ Diese Datei wurde automatisch von Lazarus erzeugt. Sie darf nicht bearbeitet 
  werden!
  Dieser Quelltext dient nur dem Übersetzen und Installieren des Packages.
 }

unit CXControls; 

interface

uses
CXCtrls, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('CXCtrls', @CXCtrls.Register); 
end; 

initialization
  RegisterPackage('CXControls', @Register); 
end.
