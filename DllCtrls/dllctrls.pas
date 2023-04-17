{ Diese Datei wurde automatisch von Lazarus erzeugt. Sie darf nicht bearbeitet 
  werden!
  Dieser Quelltext dient nur dem Übersetzen und Installieren des Packages.
 }

unit DllCtrls; 

interface

uses
  StdDllCtrls, StdDllInterfaces, StdDllType, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('StdDllCtrls',@StdDllCtrls.Register); 
end; 

initialization
  RegisterPackage('DllCtrls',@Register); 
end.
