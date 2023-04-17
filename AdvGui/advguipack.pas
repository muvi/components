{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit AdvGuiPack; 

interface

uses
    AdvGui, AdvCoord, AdvFunc, GraphX32, ChooseColor, PlatformTools, 
  StyleControls, SplitImageButtons, FormTools, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('AdvGui', @AdvGui.Register); 
  RegisterUnit('ChooseColor', @ChooseColor.Register); 
  RegisterUnit('StyleControls', @StyleControls.Register); 
  RegisterUnit('FormTools', @FormTools.Register); 
end; 

initialization
  RegisterPackage('AdvGuiPack', @Register); 
end.
