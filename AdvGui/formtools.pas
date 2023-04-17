unit FormTools;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF LCLGTK2}
  gtk2, gdk2, glib2,
  {$ENDIF}
  Classes, SysUtils, Forms, Controls, Dialogs;

type
  TFullScreen = class (TComponent)
  private
    FIsFullScreen       : Boolean;
    FOriginalWindowState: TWindowState;
    FOriginalBounds     : TRect;
    FOriginalBorderStyle: TFormBorderStyle;
  public
    constructor Create(AOwner: TComponent); override;
    procedure EnterFullScreen; inline;
    procedure LeaveFullScreen; inline;
    procedure ToggleFullScreen; inline;
  published
    property IsFullScreen: Boolean read FIsFullScreen;
  end;

procedure Register;

implementation

{TFullScreen}

constructor TFullScreen.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not AOwner.InheritsFrom(TForm)
    then ShowMessage('Diese Komponente kann nur sinnvoll auf einem Formular platziert werden.');
  FIsFullScreen:=false;
end;

procedure TFullScreen.EnterFullScreen; inline;
var
  AScreenBounds: TRect;
begin
  with TForm(Owner) do begin
    {$IFDEF LCLGTK2}
    gdk_window_fullscreen(PGtkWidget(Handle)^.window);
    {$ELSE}
    FOriginalWindowState := WindowState;
    FOriginalBounds := BoundsRect;
    FOriginalBorderStyle:=BorderStyle;

    BorderStyle := bsNone;
    AScreenBounds := Screen.MonitorFromWindow(Handle).BoundsRect;
    with AScreenBounds do SetBounds(Left, Top, Right - Left, Bottom - Top) ;
    {$ENDIF}
  end;
  FIsFullScreen:=true;
end;

procedure TFullScreen.LeaveFullScreen; inline;
begin
  with TForm(Owner) do begin
    // From full screen
    {$IFDEF LCLGTK2}
      gdk_window_unfullscreen(PGtkWidget(Handle)^.window);
    {$ELSE}
      {$IFDEF MSWINDOWS}
      BorderStyle:=FOriginalBorderStyle;
      {$ENDIF}
      if FOriginalWindowState=wsMaximized then
        WindowState:=wsMaximized
      else
        with FOriginalBounds do
          SetBounds(Left,Top,Right-Left,Bottom-Top) ;
      {$IFDEF LINUX}
      BorderStyle:=bsSizeable;
      {$ENDIF}
    {$ENDIF}
  end;
  FIsFullScreen:=false;
end;

procedure TFullScreen.ToggleFullScreen; inline;
begin
  if FIsFullScreen
    then LeaveFullScreen
    else EnterFullScreen;
end;

{Allgemein}

procedure Register;
begin
  RegisterComponents('Erweitert',[TFullScreen]);
end;

end.

