{ Diese Datei wurde automatisch von Lazarus erzeugt. Sie darf nicht bearbeitet 
  werden!
  Dieser Quelltext dient nur dem Übersetzen und Installieren des Packages.
 }

unit GR32_DSGN_L; 

interface

uses
  GR32_Reg, GR32_Dsgn_Misc, GR32_Dsgn_Color, GR32_Dsgn_Bitmap, 
  LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('GR32_Reg', @GR32_Reg.Register); 
end; 

initialization
  RegisterPackage('GR32_DSGN_L', @Register); 
end.
