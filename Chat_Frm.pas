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
  private
    FUserName: string;
    FUserId: string;
    FPageIndex: Integer;
    fLineNumberOfForm: Integer;
  public
    procedure Load(Phone: TCAbtoPhone);
    procedure ShowMessage(address: string; Msg: string);
    constructor Create(AOwner: TComponent); override;
    property UserName: string read FUserName write FUserName;
    property UserId: string read FUserId write FUserId;
    property PageIndex: Integer read FPageIndex write FPageIndex;
    property LineNumberOfForm: Integer read  fLineNumberOfForm write fLineNumberOfForm;
  end;

var
  AbtoPhone: TCAbtoPhone;

implementation

{$R *.dfm}

uses Main_Wnd;

procedure TFrameChat.ActionSendMessageExecute(Sender: TObject);
var
  i: Integer;
  cfg: Variant;
begin
  cfg := AbtoPhone.Config;
  AbtoPhone.SendTextMessage(UserName + '@iptel.org', EditMessage.Text, 0);

  ListBoxMessages.Items.Add('Ja : ');
  ListBoxMessages.Items.Add(' ' + EditMessage.Text + sLineBreak);
  EditMessage.Text := '';
end;

constructor TFrameChat.Create(AOwner: TComponent);
var
  Bitmap: TBitmap;
begin
  inherited;
end;

procedure TFrameChat.Load(Phone: TCAbtoPhone);
begin
  AbtoPhone := Phone;
  AbtoPhone.SetCurrentLine(LineNumberOfForm);
end;

procedure TFrameChat.ShowMessage(address, Msg: string);
begin
  ListBoxMessages.Items.Add(address);
  ListBoxMessages.Items.Add(' ' + Msg + sLineBreak);
end;
end.
