{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit TagControls;

interface

uses
  TagEditor, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('TagEditor', @TagEditor.Register);
end;

initialization
  RegisterPackage('TagControls', @Register);
end.
