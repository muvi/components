unit MainUnit;

(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1 or LGPL 2.1 with linking exception
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * Alternatively, the contents of this file may be used under the terms of the
 * Free Pascal modified version of the GNU Lesser General Public License
 * Version 2.1 (the "FPC modified LGPL License"), in which case the provisions
 * of this license are applicable instead of those above.
 * Please see the file LICENSE.txt for additional information concerning this
 * license.
 *
 * The Original Code is Graphics32
 *
 * The Initial Developer of the Original Code is
 * Alex A. Denisov
 *
 * Portions created by the Initial Developer are Copyright (C) 2000-2005
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * Andre Beckedorf <andre@metaexception.de>
 *
 * ***** END LICENSE BLOCK ***** *)

interface

{$I GR32.inc}

uses
  {$IFDEF FPC}LCLIntf, LResources, {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  GR32, GR32_Image, GR32_Resamplers, GR32_RangeBars;

type

  { TFormImage32Example }

  TFormImage32Example = class(TForm)
    Image: TImage32;
    Panel1: TPanel;
    Panel2: TPanel;
    rgScaleMode: TRadioGroup;
    rgKernel: TRadioGroup;
    rgBitmapAlign: TRadioGroup;
    stScale: TStaticText;
    sbScale: TGaugeBar;
    procedure rgBitmapAlignClick(Sender: TObject);
    procedure sbScaleChange(Sender: TObject);
    procedure rgScaleModeClick(Sender: TObject);
    procedure rgKernelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    Time: Single;
  end;

var
  FormImage32Example: TFormImage32Example;

implementation

{$IFNDEF FPC}
{$R *.DFM}
{$ENDIF}

uses
{$IFDEF Darwin}
  MacOSAll,
{$ENDIF}
{$IFNDEF FPC}
  JPEG;
{$ELSE}
  LazJPG;
{$ENDIF}

procedure TFormImage32Example.FormCreate(Sender: TObject);
var
{$IFDEF Darwin}
  pathRef: CFURLRef;
  pathCFStr: CFStringRef;
  pathStr: shortstring;
{$ENDIF}
  pathMedia: string;
begin
  // Under Mac OS X we need to get the location of the bundle
{$IFDEF Darwin}
  pathRef := CFBundleCopyBundleURL(CFBundleGetMainBundle());
  pathCFStr := CFURLCopyFileSystemPath(pathRef, kCFURLPOSIXPathStyle);
  CFStringGetPascalString(pathCFStr, @pathStr, 255, CFStringGetSystemEncoding());
  CFRelease(pathRef);
  CFRelease(pathCFStr);
{$ENDIF}

  // Different platforms store resource files on different locations
{$IFDEF Windows}
  {$IFDEF FPC}
  pathMedia := '..\..\..\..\Media\';
  {$ELSE}
  pathMedia := '..\..\..\Media\';
  {$ENDIF}
{$ENDIF}

{$IFDEF UNIX}
  {$IFDEF Darwin}
    pathMedia := pathStr + '/Contents/Resources/Media/';
  {$ELSE}
    pathMedia := '../../../../Media/';
  {$ENDIF}
{$ENDIF}

  // load example image
  Assert(FileExists(pathMedia + 'delphi.jpg'));
  Image.Bitmap.LoadFromFile(pathMedia + 'delphi.jpg');

  with TKernelResampler.Create(Image.Bitmap) do
  begin
    KernelMode := kmTableNearest;
    TableSize := 16;
  end;
end;

procedure TFormImage32Example.rgBitmapAlignClick(Sender: TObject);
const
  BA_CONSTS: array [0..2] of TBitmapAlign = (baTopLeft, baCenter, baTile);
begin
  Image.BitmapAlign := BA_CONSTS[rgBitmapAlign.ItemIndex];
end;

procedure TFormImage32Example.sbScaleChange(Sender: TObject);
begin
  sbScale.Update;
  Image.Scale := sbScale.Position * 0.01;
end;

procedure TFormImage32Example.rgScaleModeClick(Sender: TObject);
const
  SM_CONSTS: array [0..5] of TScaleMode = (smNormal, smStretch, smScale, smResize, smOptimal, smOptimalScaled);
var
  ScaleEnabled: Boolean;
begin
  Image.ScaleMode := SM_CONSTS[rgScaleMode.ItemIndex];
  ScaleEnabled := (rgScaleMode.ItemIndex = 2) or (rgScaleMode.ItemIndex = 5);
  sbScale.Enabled := ScaleEnabled;
  stScale.Enabled := ScaleEnabled;
end;

procedure TFormImage32Example.rgKernelClick(Sender: TObject);
const
  K_CONSTS: array [0..4] of TCustomKernelClass =
    (TBoxKernel, TLinearKernel, TSplineKernel, TLanczosKernel, TMitchellKernel);
begin
  TKernelResampler(Image.Bitmap.Resampler).Kernel := K_CONSTS[rgKernel.ItemIndex].Create;
end;

{$IFDEF FPC}
initialization
  {$I MainUnit.lrs}
{$ENDIF}

end.
