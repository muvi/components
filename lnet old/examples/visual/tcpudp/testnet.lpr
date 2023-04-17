program testnet;

{$mode objfpc}{$H+}

uses
  Interfaces, // this includes the LCL widgetset
  Forms
  { add your units here }, main;

{$IFDEF WINDOWS}{$R testnet.rc}{$ENDIF}

begin
  Application.Title:='TCP/UDP Test case';
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.

