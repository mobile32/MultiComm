unit Call_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, SIPVoipSDK_TLB, Vcl.ImgList, System.Actions,
  Vcl.ActnList;

type
  TFrameCall = class(TFrame)
    pnlMenu: TPanel;
    Menu: TGridPanel;
    GridMain: TGridPanel;
    ButtonVoice: TSpeedButton;
    ButtonVideo: TSpeedButton;
    LabelMinus: TLabel;
    TrackBarVolume: TTrackBar;
    LabelPlus: TLabel;
    ImageList: TImageList;
    Panel1: TPanel;
    GridMessageSend: TGridPanel;
    ButtonSend: TSpeedButton;
    PanelVideo: TPanel;
    ListBoxMessages: TListBox;
    ButtonClose: TSpeedButton;
    ActionList1: TActionList;
    ActionCall: TAction;
    ActionSendMessage: TAction;
    ButtonCall: TSpeedButton;
    ActionCamera: TAction;
    EditMessage: TEdit;
    ActionMute: TAction;
    procedure ActionSendMessageExecute(Sender: TObject);
    procedure ActionCallExecute(Sender: TObject);
    procedure ActionCameraExecute(Sender: TObject);
    procedure LabelMinusClick(Sender: TObject);
    procedure LabelPlusClick(Sender: TObject);
    procedure PanelVideoClick(Sender: TObject);
    procedure TrackBarVolumeChange(Sender: TObject);
    procedure ActionMuteExecute(Sender: TObject);
  private
    FUserName: string;
    FUserId: string;
    FPageIndex : Integer;
  public
    gIsCallEstablish: Boolean;
    procedure Load(Phone: TCAbtoPhone);
    procedure ShowMessage(Address, Msg :string);
    constructor Create(AOwner: TComponent); override;
    property UserName: string read FUserName write FUserName;
    property UserId: string read FUserName write FUserId;
    property PageIndex : Integer read FPageIndex write FPageIndex;
  published
    property ClientHeight;
    property ClientWidth;
  end;

var
  AbtoPhone: TCAbtoPhone;
  gMute,gVideoShow,gShowSelf: Boolean;
  gLastTrackVolumePosition : Integer;

implementation

{$R *.dfm}

uses Main_Wnd;

procedure TFrameCall.ActionCallExecute(Sender: TObject);
var
  tmpBitmap: TBitmap;
begin
  if gIsCallEstablish = False then
  begin
    tmpBitmap := TBitmap.Create();
    ImageList.GetBitmap(4, tmpBitmap);
    ButtonCall.Glyph := tmpBitmap;
    gIsCallEstablish := True;
    AbtoPhone.HangUpLastCall;
  end
  else
  begin
    tmpBitmap := TBitmap.Create();
    ImageList.GetBitmap(3, tmpBitmap);
    ButtonCall.Glyph := tmpBitmap;
    gIsCallEstablish := False;
    AbtoPhone.StartCall(UserName + '@iptel.org');
  end;
end;

procedure TFrameCall.ActionCameraExecute(Sender: TObject);
var
  phoneConfig : Variant;
begin
  phoneConfig := AbtoPhone.Config;

  if gVideoShow then
    begin
    phoneConfig.RemoteVideoWindow := PanelVideo.Handle;
    end
  else
  begin
    phoneConfig.RemoteVideoWindow := nil;
    phoneConfig.LocalVideoWindow := nil;
  end;

  AbtoPhone.ApplyConfig;
end;

procedure TFrameCall.ActionMuteExecute(Sender: TObject);
begin
  if gMute then
  begin
    gLastTrackVolumePosition := TrackBarVolume.Position;
    TrackBarVolume.Position := 0;
  end
  else
  begin
    TrackBarVolume.Position := gLastTrackVolumePosition;
  end;
end;

procedure TFrameCall.ActionSendMessageExecute(Sender: TObject);
var
  i : Integer;
  cfg : Variant;
begin
  cfg := AbtoPhone.Config;
  AbtoPhone.SendTextMessage(UserName + '@iptel.org',EditMessage.Text,1);

  ListBoxMessages.Items.Add('Ja : ');
  ListBoxMessages.Items.Add(' ' + EditMessage.Text);
  EditMessage.Text :='';
end;

procedure TFrameCall.ShowMessage(Address, Msg : string);
begin
  ListBoxMessages.Items.Add(Address + ': ');
  ListBoxMessages.Items.Add(Msg);
end;

procedure TFrameCall.TrackBarVolumeChange(Sender: TObject);
begin
    AbtoPhone.PlaybackVolume := TrackBarVolume.Position
end;

constructor TFrameCall.Create(AOwner: TComponent);
begin
  inherited;
  ButtonClose.Caption := '';
  ButtonSend.Caption :='';
  ButtonVoice.Caption := '';
  ButtonCall.Caption := '';
  ButtonVideo.Caption :='';
end;

procedure TFrameCall.LabelMinusClick(Sender: TObject);
begin
  if TrackBarVolume.Position > 0 then
    TrackBarVolume.Position := TrackBarVolume.Position - 1;
end;

procedure TFrameCall.LabelPlusClick(Sender: TObject);
begin
  if TrackBarVolume.Position < 10 then
    TrackBarVolume.Position := TrackBarVolume.Position + 1
end;

procedure TFrameCall.Load(Phone: TCAbtoPhone);
begin
  AbtoPhone := Phone;
  gIsCallEstablish := False;
  gShowSelf := False;
  TrackBarVolume.Position := AbtoPhone.PlaybackVolume;
end;

procedure TFrameCall.PanelVideoClick(Sender: TObject);
var
  phoneConfig : Variant;
begin
  phoneConfig := AbtoPhone.Config;

  if gShowSelf and gVideoShow then
    begin
    phoneConfig.LocalVideoWindow := PanelVideo.Handle;
    gShowSelf := False;
    end
  else if not gShowSelf and gVideoShow then
    begin
    phoneConfig.RemoteVideoWindow := PanelVideo.Handle;
    gShowSelf := True;
    end;

  AbtoPhone.ApplyConfig;
end;

end.
