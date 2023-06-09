object Form1: TForm1
  Left = 540
  Top = 394
  Caption = 'RadioRecorder'
  ClientHeight = 273
  ClientWidth = 466
  Color = 3763336
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    466
    273)
  PixelsPerInch = 96
  TextHeight = 13
  object Label14: TLabel
    Left = 11
    Top = 72
    Width = 3
    Height = 13
  end
  object Label15: TLabel
    Left = 240
    Top = 72
    Width = 35
    Height = 13
    Caption = 'Volume'
  end
  object Label16: TLabel
    Left = 128
    Top = 72
    Width = 30
    Height = 13
    Caption = 'Bitrate'
  end
  object TLabel
    Left = 8
    Top = 109
    Width = 54
    Height = 13
    Caption = 'Signal level'
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 40
    Width = 65
    Height = 25
    Caption = 'Play'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 88
    Top = 40
    Width = 49
    Height = 25
    Caption = 'Pause'
    DoubleBuffered = True
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BitBtn2Click
  end
  object BitBtn3: TBitBtn
    Left = 151
    Top = 40
    Width = 49
    Height = 26
    Caption = 'Stop'
    DoubleBuffered = True
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = BitBtn3Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 254
    Width = 466
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentColor = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 173
    Width = 466
    Height = 81
    Align = alBottom
    BevelOuter = bvNone
    Color = 2240534
    TabOrder = 4
    DesignSize = (
      466
      81)
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 23
      Height = 13
      Caption = 'Artist'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label3: TLabel
      Left = 48
      Top = 8
      Width = 32
      Height = 13
      Caption = 'Label3'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label5: TLabel
      Left = 8
      Top = 24
      Width = 29
      Height = 13
      Caption = 'Album'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label9: TLabel
      Left = 48
      Top = 24
      Width = 32
      Height = 13
      Caption = 'Label9'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label10: TLabel
      Left = 8
      Top = 40
      Width = 20
      Height = 13
      Caption = 'Title'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label11: TLabel
      Left = 48
      Top = 40
      Width = 257
      Height = 13
      AutoSize = False
      Caption = 'Label11'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label12: TLabel
      Left = 8
      Top = 56
      Width = 22
      Height = 13
      Caption = 'Year'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label13: TLabel
      Left = 48
      Top = 56
      Width = 38
      Height = 13
      Caption = 'Label13'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label4: TLabel
      Left = 331
      Top = 8
      Width = 62
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'samplerate'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ExplicitLeft = 318
    end
    object Label1: TLabel
      Left = 333
      Top = 24
      Width = 73
      Height = 17
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'bitrate'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ExplicitLeft = 320
    end
    object Label6: TLabel
      Left = 333
      Top = 56
      Width = 57
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Total time'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ExplicitLeft = 320
    end
    object Label7: TLabel
      Left = 397
      Top = 56
      Width = 39
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Label7'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ExplicitLeft = 384
    end
    object Label8: TLabel
      Left = 333
      Top = 40
      Width = 31
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'mono'
      Color = 1716752
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ExplicitLeft = 320
    end
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 162
    Width = 466
    Height = 11
    Align = alBottom
    TabOrder = 5
  end
  object ComboBox1: TComboBox
    Left = 0
    Top = 8
    Width = 458
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 6
    Text = 'ComboBox1'
  end
  object RecordButton: TButton
    Left = 216
    Top = 40
    Width = 105
    Height = 25
    Caption = 'Start/Stop record'
    TabOrder = 7
    OnClick = RecordButtonClick
  end
  object PauseRecordButton: TButton
    Left = 328
    Top = 40
    Width = 81
    Height = 25
    Caption = 'Pause Record'
    TabOrder = 8
    OnClick = PauseRecordButtonClick
  end
  object TrackBar1: TTrackBar
    Left = 280
    Top = 72
    Width = 161
    Height = 24
    Max = 0
    Min = -4000
    Frequency = 4
    TabOrder = 9
    ThumbLength = 12
    TickStyle = tsNone
    OnChange = TrackBar1Change
  end
  object Edit1: TEdit
    Left = 168
    Top = 72
    Width = 57
    Height = 21
    TabOrder = 10
    Text = '256'
  end
  object ProgressBar2: TProgressBar
    Left = 8
    Top = 128
    Width = 450
    Height = 16
    Anchors = [akLeft, akTop, akRight]
    MarqueeInterval = 5
    BarColor = clLime
    BackgroundColor = clBlack
    TabOrder = 11
  end
  object OpenDialog1: TOpenDialog
    Filter = 'WMA files|*.wma'
    Left = 256
    Top = 208
  end
  object WMStreamedIn1: TWMStreamedIn
    Loop = False
    BufferingTime = 2
    EnableHTTP = False
    EnableTCP = False
    EnableUDP = False
    MaxWaitMilliseconds = 10000
    ProxyPort = 0
    StretchFactor = 1.000000000000000000
    OnStreamOpened = WMStreamedIn1StreamOpened
    OnStartedPlaying = WMStreamedIn1StartedPlaying
    Left = 56
    Top = 160
  end
  object WMATap1: TWMATap
    Input = FastResampler1
    DesiredBitrate = 0
    Lossless = False
    VBR = False
    VBRQuality = 0
    Left = 160
    Top = 160
  end
  object FastGainIndicator1: TFastGainIndicator
    Input = WMATap1
    Interval = 60
    OnGainData = GainIndicator1GainData
    Left = 224
    Top = 160
  end
  object FastResampler1: TFastResampler
    Input = WMStreamedIn1
    OutSampleRate = 22050
    Left = 96
    Top = 160
  end
  object DXAudioOut1: TDXAudioOut
    Input = FastGainIndicator1
    DeviceNumber = 0
    Latency = 100
    PrefetchData = True
    PollingInterval = 100
    FramesInBuffer = 24576
    SpeedFactor = 1.000000000000000000
    Left = 320
    Top = 160
  end
end
