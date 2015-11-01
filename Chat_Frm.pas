unit Chat_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, SIPVoipSDK_TLB, Vcl.ImgList, System.Actions, Vcl.ActnList;

type
  TFrameChat = class(TFrame)
    PanelMessage: TPanel;
    Grid: TGridPanel;
    ButtonSend: TSpeedButton;
    SpeedButtonRead: TSpeedButton;
    SpeedButtonWrite: TSpeedButton;
    ListBoxMessages: TListBox;
    ImageList: TImageList;
    ActionList: TActionList;
    ActionSendMessage: TAction;
    EditMessage: TEdit;
    procedure ActionSendMessageExecute(Sender: TObject);
  private
    FUserName  : string;
    FUserId : string;
    FPageIndex : Integer;
  public
    procedure Load(Phone: TCAbtoPhone);
    procedure ShowMessage(Address: string;  Msg : string);
    constructor Create(AOwner: TComponent); override;
    property UserName : string read FUserName write FUserName;
    property UserId : string read FUserId write FUserId;
    property PageIndex : Integer read FPageIndex write FPageIndex;
  end;
  var
    AbtoPhone : TCAbtoPhone;

implementation
{$R *.dfm}

uses Main_Wnd;

procedure TFrameChat.ActionSendMessageExecute(Sender: TObject);
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

constructor TFrameChat.Create(AOwner: TComponent);
var
  Bitmap : TBitmap;
begin
  inherited;
  ButtonSend.Caption := '';
  Bitmap := TBitmap.Create();
  ImageList.GetBitmap(0,Bitmap);
end;

procedure TFrameChat.Load(Phone: TCAbtoPhone);
begin
  AbtoPhone := Phone;
end;

procedure TFrameChat.ShowMessage(Address, Msg: string);
begin
  ListBoxMessages.Items.Add(Address);
  ListBoxMessages.Items.Add(Msg);
end;

end.
