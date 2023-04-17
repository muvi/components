unit LCLAdvFunc;

{$mode objfpc}{$H+}

interface

uses
  AdvFunc, Dialogs, LCLType, PLatformTools;

type
  TMessageType   = record
    Sound    : Cardinal;
    Pic      : TMsgDlgType;
    PlaySound: Boolean;
    DoExit   : Boolean;
    Buttons  : TMsgDlgButtons;
    HelpCtx  : Integer;
  end;

const
  TdMError       : TMessageType=(Sound:MB_OK;Pic:mtError;PlaySound:true;DoExit:false;Buttons:([mbOK]);HelpCtx:0);
  TdMFError      : TMessageType=(Sound:MB_ICONHAND;Pic:mtError;PlaySound:true;DoExit:false;Buttons:([mbOK]);HelpCtx:0);
  TdMWarnung     : TMessageType=(Sound:MB_ICONASTERISK;Pic:mtWarning;PlaySound:true;DoExit:false;Buttons:([mbOK]);HelpCtx:0);
  TdMInfo        : TMessageType=(Sound:MB_ICONEXCLAMATION;Pic:mtInformation;PlaySound:true;DoExit:false;Buttons:([mbOK]);HelpCtx:0);
  TdMFrage       : TMessageType=(Sound:MB_ICONQUESTION;Pic:mtConfirmation;PlaySound:true;DoExit:false;Buttons:mbYesNo;HelpCtx:0);
  TdMExceptionQ  : TMessageType=(Sound:MB_ICONHAND;Pic:mtError;PlaySound:true;DoExit:false;Buttons:mbYesNo;HelpCtx:0);
  TdMAbbruchFrage: TMessageType=(Sound:MB_ICONQUESTION;Pic:mtConfirmation;PlaySound:true;DoExit:false;Buttons:mbYesNoCancel;HelpCtx:0);
  TdMNormal      : TMessageType=(Sound:0;Pic:mtCustom;PlaySound:false;DoExit:false;Buttons:([mbOK]);HelpCtx:0);
  TdMExitError   : TMessageType=(Sound:MB_ICONHAND;Pic:mtError;PlaySound:true;DoExit:true;Buttons:([mbOK]);HelpCtx:0);
  TdMCBError     : TMessageType=(Sound:$FFFFFFFF;Pic:mtError;PlaySound:true;DoExit:false;Buttons:([mbOK]);HelpCtx:0);
  //TdMUser        : TMessageType=(Sound:MB_USERICON;Pic:mtCustom;PlaySound:true;DoExit:false;Buttons:([mbOK]);HelpCtx:0);
  TdMYesAbort    : TMessageType=(Sound:MB_ICONASTERISK;Pic:mtWarning;PlaySound:true;DoExit:false;Buttons:([mbYes,mbAbort]);HelpCtx:0);
  TdMCrazy       : TMessageTYpe=(Sound:MB_ABORTRETRYIGNORE; Pic:mtConfirmation; PlaySound:true; DoExit:false; Buttons:[mbYes,mbNo,mbOK,mbCancel,mbAbort,mbRetry,mbIgnore,mbAll,mbNoToAll,mbYesToAll,mbHelp,mbClose]; HelpCtx:0);

function AdvMsg(S: string; MessageType: TMessageType): Integer;

implementation

function AdvMsg(S: string; MessageType: TMessageType): Integer;
begin
  with MessageType do begin
    if PlaySound then MessageBeep(Sound);
    Result:=MessageDlg(S,Pic,Buttons,HelpCtx);
    if DoExit then halt;
  end;
end;

end.

