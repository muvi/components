unit PlatformTools;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils;

procedure MessageBeep(ASound: Cardinal);

implementation

procedure MessageBeep(ASound: Cardinal);
begin
  {$IFDEF MWINDOWS}
  Windows.MessageBeep(ASound);
  {$ENDIF}
  //sonst gar kein Beep...
end;

end.

