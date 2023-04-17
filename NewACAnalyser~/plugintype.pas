unit PluginType; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DllStr;

type
  MVPluginID    = array [0..31] of Char;

  IMInterface   = interface
    ['{78C02B09-125B-4786-9EF2-80CC9FE9DC35}']
    function GetVersion: MVVersion; stdcall;
    function Future(const Version: MVVersion): IMInterface; stdcall;
  end;

  IMPlugin      = interface (IMInterface)
    ['{CFE10EB4-5359-4406-9CF8-1A5FE070B22C}']
    function GetID: MVPluginID; stdcall;
    function GetName: ShortString; stdcall;
    procedure Init; stdcall;
    procedure Done; stdcall;
  end;

  IMPluginSystem= interface (IMInterface)
    ['{E65398DC-3387-42B5-A533-8A2E8A91A02B}']
    function GetPlugin(const ID: MVPluginID): IMPlugin; stdcall;
    procedure InstallPlugin(Plugin: IMPlugin); stdcall;
  end;

implementation

end.

