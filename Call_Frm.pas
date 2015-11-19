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
    PanelMenu: TPanel;
    GridPanelMenu: TGridPanel;
    GridMain: TGridPanel;
    LabelMinus: TLabel;
    TrackBarVolume: TTrackBar;
    LabelPlus: TLabel;
    ImageList: TImageList;
    GridMessageSend: TGridPanel;
    ListBoxMessages: TListBox;
    ActionList1: TActionList;
    ActionCall: TAction;
    ActionSendMessage: TAction;
    ActionCamera: TAction;
    EditMessage: TEdit;
    ActionMute: TAction;
    ButtonMute: TButton;
    ButtonSendMessage: TButton;
    PanelButton: TPanel;
    ButtonCall: TButton;
    ButtonHangUp: TButton;
    ActionHangUp: TAction;
    procedure ActionSendMessageExecute(Sender: TObject);
    procedure ActionCallExecute(Sender: TObject);
    procedure LabelMinusClick(Sender: TObject);
    procedure LabelPlusClick(Sender: TObject);
    procedure TrackBarVolumeChange(Sender: TObject);
    procedure ActionMuteExecute(Sender: TObject);
    procedure AbtoPhone_OnEstablishedCall(ASender: TObject;
      const Msg: WideString; LineId: Integer);
    procedure AbtoPhone_OnClearedCall(ASender: TObject; const Msg: WideString;
      Status, LineId: Integer);
    procedure ActionHangUpExecute(Sender: TObject);
  private
    FUserName: string;
    FUserId: string;
    FPageIndex: Integer;
    fLineNumberOfForm: Integer;
  public
    gIsCallEstablish: Boolean;
    constructor Create(AOwner: TComponent); override;
    procedure Load(Phone: TCAbtoPhone);
    procedure ShowMessage(Address, Msg: string);
    property UserName: string read FUserName write FUserName;
    property UserId: string read FUserName write FUserId;
    property PageIndex: Integer read FPageIndex write FPageIndex;
  published
    property ClientHeight;
    property ClientWidth;
    property LineNumberOfForm: Integer read  fLineNumberOfForm write fLineNumberOfForm;
  end;

var
  AbtoPhone: TCAbtoPhone;
  gMute, gVideoShow, gShowSelf: Boolean;
  gLastTrackVolumePosition: Integer;

implementation

{$R *.dfm}

uses Main_Wnd;

procedure TFrameCall.AbtoPhone_OnClearedCall(ASender: TObject;
  const Msg: WideString; Status, LineId: Integer);
begin
  gIsCallEstablish := False;
end;

procedure TFrameCall.AbtoPhone_OnEstablishedCall(ASender: TObject;
  const Msg: WideString; LineId: Integer);
begin
  gIsCallEstablish := True;
end;


procedure TFrameCall.ActionCallExecute(Sender: TObject);
begin
  AbtoPhone.StartCall(UserName + '@iptel.org');
  gIsCallEstablish := True;
  ButtonCall.Visible := False;
  ButtonHangUp.Visible := True;
end;

procedure TFrameCall.ActionHangUpExecute(Sender: TObject);
begin
  AbtoPhone.HangUpLastCall;
  gIsCallEstablish := False;
  ButtonCall.Visible := True;
  ButtonHangUp.Visible := False;
end;

procedure TFrameCall.ActionMuteExecute(Sender: TObject);
begin
  if gMute then
  begin
    gLastTrackVolumePosition := TrackBarVolume.Position;
    TrackBarVolume.Position := 0;
    ButtonMute.ImageIndex := 5;
  end
  else
  begin
    TrackBarVolume.Position := gLastTrackVolumePosition;
    ButtonMute.ImageIndex := 4;
  end;
end;

procedure TFrameCall.ActionSendMessageExecute(Sender: TObject);
var
  i: Integer;
  cfg: Variant;
begin
  cfg := AbtoPhone.Config;
  AbtoPhone.SendTextMessage(UserName + '@iptel.org', EditMessage.Text, 0);

  ListBoxMessages.Items.Add('Ja : ');
  ListBoxMessages.Items.Add(' ' + EditMessage.Text);
  ListBoxMessages.Items.Add('\n');
  EditMessage.Text := '';
end;

procedure TFrameCall.ShowMessage(Address, Msg: string);
begin
  ListBoxMessages.Items.Add(address);
  ListBoxMessages.Items.Add(' ' + Msg);
  ListBoxMessages.Items.Add('\n');
end;

procedure TFrameCall.TrackBarVolumeChange(Sender: TObject);
begin
  AbtoPhone.PlaybackVolume := TrackBarVolume.Position
end;

constructor TFrameCall.Create(AOwner: TComponent);
begin
  inherited;
  gIsCallEstablish := False;
  ButtonCall.Caption := '';
  ButtonMute.Caption := '';
  ButtonSendMessage.Caption := '';
  TrackBarVolume.Position := 5;
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
  AbtoPhone.SetCurrentLine(LineNumberOfForm);
  AbtoPhone.OnEstablishedCall := AbtoPhone_OnEstablishedCall;
  AbtoPhone.OnClearedCall := AbtoPhone_OnClearedCall;
  gShowSelf := False;
  TrackBarVolume.Position := 5;
  TrackBarVolume.Position := AbtoPhone.PlaybackVolume;
end;

end.
