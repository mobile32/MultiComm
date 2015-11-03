unit Chat_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, SIPVoipSDK_TLB, Vcl.ImgList, System.Actions, Vcl.ActnList;

type
  TFrameChat = class(TFrame)
    PanelMessage: TPanel;
    Grid: TGridPanel;
    ListBoxMessages: TListBox;
    ImageList: TImageList;
    ActionList: TActionList;
    ActionSendMessage: TAction;
    EditMessage: TEdit;
    ButtonSendMessage: TButton;
    ButtonSpeak: TButton;
    ButtonRec: TButton;
    procedure ActionSendMessageExecute(Sender: TObject);
    procedure AbtoPhone_OnTextMessageReceived(ASender: TObject;
      const address: WideString; const message: WideString);
  private
    FUserName: string;
    FUserId: string;
    FPageIndex: Integer;
  public
    procedure Load(Phone: TCAbtoPhone);
    procedure ShowMessage(address: string; Msg: string);
    constructor Create(AOwner: TComponent); override;
    property UserName: string read FUserName write FUserName;
    property UserId: string read FUserId write FUserId;
    property PageIndex: Integer read FPageIndex write FPageIndex;
  end;

var
  AbtoPhone: TCAbtoPhone;

implementation

{$R *.dfm}

uses Main_Wnd;

procedure TFrameChat.AbtoPhone_OnTextMessageReceived(ASender: TObject;
  const address, message: WideString);
begin
  ListBoxMessages.Items.Add(message);
end;

procedure TFrameChat.ActionSendMessageExecute(Sender: TObject);
var
  i: Integer;
  cfg: Variant;
begin
  cfg := AbtoPhone.Config;
  AbtoPhone.SendTextMessage(UserName + '@iptel.org', EditMessage.Text, 1);

  ListBoxMessages.Items.Add('Ja : ');
  ListBoxMessages.Items.Add(' ' + EditMessage.Text);
  EditMessage.Text := '';
end;

constructor TFrameChat.Create(AOwner: TComponent);
var
  Bitmap: TBitmap;
begin
  inherited;
  AbtoPhone.OnTextMessageReceived := AbtoPhone_OnTextMessageReceived;
end;

procedure TFrameChat.Load(Phone: TCAbtoPhone);
begin
  AbtoPhone := Phone;
end;

procedure TFrameChat.ShowMessage(address, Msg: string);
begin
  ListBoxMessages.Items.Add(address);
  ListBoxMessages.Items.Add(Msg);
end;

end.
