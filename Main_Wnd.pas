unit Main_Wnd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  System.Actions, Vcl.ActnList, Vcl.Menus, Vcl.ComCtrls, Chat_Frm, Call_Frm,
  Vcl.ImgList, Login_Wnd, Settings_Wnd, SipVoipSDK_TLB, Contacts_Wnd, StrUtils,
  Vcl.Styles,Vcl.Tabs;

type
  TContact = record
    Id: Integer;
    Image: string;
    Name: string;
    CallerId: string;
    OpenPage: Integer;
  end;

  TContacts = array of TContact;

  TFormMainWindow = class(TForm)
    PageControl: TPageControl;
    TabSheetContatcs: TTabSheet;
    ActionList: TActionList;
    ActionCall: TAction;
    ActionChat: TAction;
    ActionSettings: TAction;
    ActionLogin: TAction;
    ImageList: TImageList;
    ActionCloseCall: TAction;
    ActionCloseChat: TAction;
    Panel2: TPanel;
    ButtonSettings: TSpeedButton;
    ButtonLogin: TSpeedButton;
    Panel1: TPanel;
    ListViewContacts: TListView;
    ButtonContacts: TSpeedButton;
    Panel3: TPanel;
    ButtonMessage: TSpeedButton;
    ButtonCall: TSpeedButton;
    ActionContactsList: TAction;
    procedure ActionCallExecute(Sender: TObject);
    procedure ActionChatExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ActionSettingsExecute(Sender: TObject);
    procedure ActionLoginExecute(Sender: TObject);
    procedure ActionCloseChatExecute(Sender: TObject);
    procedure ActionContactsListExecute(Sender: TObject);
    procedure AbtoPhone_OnRegistered(ASender: TObject; const Msg: WideString);
    procedure AbtoPhone_OnIncomingCall(ASender: TObject;
      const AddrFrom: WideString; LineId: Integer);
    procedure AbtoPhone_OnClearedCall(ASender: TObject; const Msg: WideString;
      Status, LineId: Integer);
    procedure AbtoPhone_OnEstablishedCall(ASender: TObject;
      const Msg: WideString; LineId: Integer);
    procedure AbtoPhone_OnTextMessageReceived(ASender: TObject;
      const address: WideString; const message: WideString);
  private
    procedure OpenCallFrm(UserName, CallerId: string);
    procedure OpenChatFrm(UserName, CallerId: string);
    procedure LoadConfig();
    function ExtractBetween(const Value, A, B: string): string;
  public
    gIsCallEstablish: Boolean;
    AbtoPhone: TCAbtoPhone;

  end;

var
  FormMainWindow: TFormMainWindow;
  AbtoPhone: TCAbtoPhone;
  LoginWindow: TFormLog;
  gContacts: TContacts;
  gTabSheets: array of TTabSheet;
  gFrameChats: array of TFrameChat;
  gFrameCalls: array of TFrameCall;

implementation

{$R *.dfm}

procedure TFormMainWindow.ActionCallExecute(Sender: TObject);
var
  i, j, index: Integer;
  UserName, CallerId: string;
begin
  if ListViewContacts.Selected.Selected then
  begin
    index := ListViewContacts.Selected.index;
    UserName := gContacts[index].Name;
    CallerId := gContacts[index].CallerId;

    gContacts[index].OpenPage := High(gTabSheets) + 2;

    OpenCallFrm(UserName, CallerId);
  end;
end;

procedure TFormMainWindow.ActionChatExecute(Sender: TObject);
var
  index: Integer;
  CallerId, UserName: string;
begin
  if ListViewContacts.Selected.Selected then
  begin
    index := ListViewContacts.Selected.index;
    CallerId := gContacts[index].CallerId;
    UserName := gContacts[index].Name;

    gContacts[index].OpenPage := High(gTabSheets) + 2;

    OpenChatFrm(UserName, CallerId);
  end;
end;

procedure TFormMainWindow.ActionCloseChatExecute(Sender: TObject);
var
  ChatFrame: TFrameChat;
  TabSheet: TTabSheet;
  Button: TSpeedButton;
  i: Integer;
begin
  //
end;

procedure TFormMainWindow.ActionContactsListExecute(Sender: TObject);
var
  ContactsListWindow: TFormContactsList;
begin
  ContactsListWindow := TFormContactsList.Create(Self);
  ContactsListWindow.Show;
end;

procedure TFormMainWindow.ActionLoginExecute(Sender: TObject);
begin
  AbtoPhone := TCAbtoPhone.Create(Self);
  LoadConfig;
  AbtoPhone.Initialize;
  LoginWindow := TFormLog.Create(Self);
  LoginWindow.Load(AbtoPhone);
  LoginWindow.Show;
end;

procedure TFormMainWindow.ActionSettingsExecute(Sender: TObject);
var
  SettingsWindow: TFormSettings;
begin
  SettingsWindow := TFormSettings.Create(Self);
  SettingsWindow.Load(AbtoPhone);

  if SettingsWindow.ShowModal() = mrOk then
  begin

  end;
  SettingsWindow.Free;
  SettingsWindow := nil;
end;

procedure TFormMainWindow.OpenCallFrm(UserName, CallerId: string);
var
  i, j: Integer;
begin
  i := Length(gTabSheets);
  SetLength(gTabSheets, Length(gTabSheets) + 1);
  gTabSheets[i] := TTabSheet.Create(nil);
  gTabSheets[i].Caption := 'Rozmowa z ' + CallerId;
  gTabSheets[i].PageControl := PageControl;
  gTabSheets[i].PageIndex := i + 1;
  gTabSheets[i].Show;

  j := Length(gFrameCalls);
  SetLength(gFrameCalls, Length(gFrameCalls) + 1);

  gFrameCalls[j] := TFrameCall.Create(nil);
  gFrameCalls[j].Parent := gTabSheets[i];
  gFrameCalls[j].Align := alClient;
  gFrameCalls[j].Name := 'FrameCall' + IntToStr(j);
  // gFrameChats[j].PageIndex := gTabSheets[i].PageIndex;

  gFrameCalls[j].UserName := UserName;
  gFrameCalls[j].Load(AbtoPhone);

  gFrameCalls[j].Parent := gTabSheets[i];
end;

procedure TFormMainWindow.OpenChatFrm(UserName, CallerId: string);
var
  i, j: Integer;
begin
  i := Length(gTabSheets);
  SetLength(gTabSheets, Length(gTabSheets) + 1);
  gTabSheets[i] := TTabSheet.Create(nil);
  gTabSheets[i].Caption := 'Czat z ' + CallerId;
  gTabSheets[i].PageControl := PageControl;
  gTabSheets[i].PageIndex := i + 1;
  gTabSheets[i].Show;

  j := Length(gFrameChats);
  SetLength(gFrameChats, Length(gFrameChats) + 1);

  gFrameChats[j] := TFrameChat.Create(nil);
  gFrameChats[j].Parent := gTabSheets[i];
  gFrameChats[j].Align := alClient;
  gFrameChats[j].Name := 'FrameChat' + IntToStr(j);
  gFrameChats[j].PageIndex := gTabSheets[i].PageIndex;

  gFrameChats[j].UserName := UserName;
  gFrameChats[j].Load(AbtoPhone);

  gFrameChats[j].Parent := gTabSheets[i];
end;

procedure TFormMainWindow.LoadConfig;
var
  phoneConfig: Variant;
begin
  phoneConfig := AbtoPhone.Config;
  AbtoPhone.OnRegistered := AbtoPhone_OnRegistered;
  AbtoPhone.OnIncomingCall := AbtoPhone_OnIncomingCall;
  AbtoPhone.OnClearedCall := AbtoPhone_OnClearedCall;
  AbtoPhone.OnEstablishedCall := AbtoPhone_OnEstablishedCall;

  phoneConfig.ListenPort := 5060;
  phoneConfig.RegDomain := 'iptel.org';
  phoneConfig.LicenseUserId :=
    'Trial3848-8749-FFFF-F3469758-2111-2C1A-E7DB-4FF723D0C845';
  phoneConfig.LicenseKey :=
    'wqtVfeWUf3IQLuUojNKRZ4YgW35CaNkTfwiv4LYrLUDk4cAn5NYWR/Kb35y1eZnNdIema0pxBOxhCakcy7LF2A==';

  AbtoPhone.ApplyConfig;
end;

function TFormMainWindow.ExtractBetween(const Value, A, B: string): string;
var
  aPos, bPos: Integer;
begin
  result := '';
  aPos := Pos(A, Value);
  if aPos > 0 then
  begin
    aPos := aPos + Length(A);
    bPos := PosEx(B, Value, aPos);
    if bPos > 0 then
    begin
      result := Copy(Value, aPos, bPos - aPos);
    end;
  end;
end;

procedure TFormMainWindow.FormClose(Sender: TObject; var Action: TCloseAction);
var
  tmpTabSheet: TTabSheet;
  tmpFrameChat: TFrameChat;
  tmpFrameCall: TFrameCall;
  i: Integer;
begin
  if gIsCallEstablish then
    AbtoPhone.HangUpLastCall;

  AbtoPhone.Free;
end;

procedure TFormMainWindow.FormCreate(Sender: TObject);
var
  Item: TListItem;
  i: Integer;
begin
  AbtoPhone := TCAbtoPhone.Create(Self);
  LoadConfig;
  AbtoPhone.Initialize;
  ButtonMessage.Caption := '';
  ButtonCall.Caption := '';

  SetLength(gContacts, 5);
  gContacts[0].Name := 'mobile32';
  gContacts[1].Name := 'marzencia93';
  gContacts[2].Name := 'malgorzatamaz';
  gContacts[3].Name := 'hpereverzieva';
  gContacts[4].Name := 'music';

  gContacts[0].CallerId := 'Grzesiek';
  gContacts[1].CallerId := 'Marzenka';
  gContacts[2].CallerId := 'Gosia';
  gContacts[3].CallerId := 'Ania';
  gContacts[4].CallerId := 'Muzyka';

  ListViewContacts.SmallImages := ImageList;

  for i := 0 to High(gContacts) do
  begin
    Item := ListViewContacts.Items.Add();
    Item.Caption := gContacts[i].CallerId;
    Item.ImageIndex := i + 2;
  end;

  LoginWindow := TFormLog.Create(nil);
  LoginWindow.Load(AbtoPhone);
  Self.Enabled := False;
  LoginWindow.FormStyle := fsStayOnTop;
  LoginWindow.Show;
end;

procedure TFormMainWindow.AbtoPhone_OnIncomingCall(ASender: TObject;
  const AddrFrom: WideString; LineId: Integer);
var
  gExist: Boolean;
  i, x: Integer;
  UserName, CallerId: string;
begin
  gExist := False;
  UserName := AddrFrom;

  for i := 0 to High(gFrameCalls) do
  begin
    if gFrameCalls[i].UserName = AddrFrom then
    begin
      gExist := True;
      CallerId := gFrameCalls[i].UserId;
    end;
  end;

  if gIsCallEstablish then
  begin
    x := MessageDlg('Dzwoni ' + AddrFrom + ', przerwa� poprzedni� rozmow�?',
      mtConfirmation, mbYesNo, 0);
  end
  else
  begin
    x := MessageDlg('Dzwoni ' + AddrFrom + ', odebra�?', mtConfirmation,
      mbYesNo, 0);
  end;

  if x = mrYes then
  begin
    if gIsCallEstablish then
    begin
      AbtoPhone.HangUpLastCall;
    end
    else
    begin
      if not gExist then
      begin
        OpenCallFrm(UserName, CallerId);
      end
      else
      begin
        for i := 0 to High(gContacts) do
        begin
          if gContacts[i].Name = UserName then
          begin
            PageControl.ActivePageIndex := gContacts[i].OpenPage;
          end;
        end;
      end;
      gIsCallEstablish := True;

      AbtoPhone.AnswerCall;
    end;
  end
  else
    AbtoPhone.RejectCall;
end;

procedure TFormMainWindow.AbtoPhone_OnRegistered(ASender: TObject;
  const Msg: WideString);
var
  lmessage: string;
begin
  lmessage := Msg;
  if Pos('200', lmessage) > 0 then
  begin
    Self.Caption := 'MultiComm - Zalogowano jako ' + AbtoPhone.Config.RegUser;

    LoginWindow.LoginSucessfull;
    LoginWindow.Close;
    LoginWindow.Free;
    LoginWindow := nil;
    Self.Enabled := True;
    Self.Activate;
  end
  else
  begin
    LoginWindow.LoginUnsucessful;
  end;
end;

procedure TFormMainWindow.AbtoPhone_OnTextMessageReceived(ASender: TObject;
  const address, message: WideString);
var
  gExist: Boolean;
  i, x: Integer;
  UserName, CallerId: string;
  tmpFrameChat: TFrameChat;
  tmpFrameCall: TFrameCall;
begin
  gExist := False;
  UserName := address;

  for i := 0 to High(gFrameCalls) do
  begin
    if gFrameCalls[i].UserName = address then
    begin
      gExist := True;
      CallerId := gFrameCalls[i].UserId;
      tmpFrameCall := gFrameCalls[i];
    end;
  end;

  for i := 0 to High(gFrameChats) do
  begin
    if gFrameChats[i].UserName = address then
    begin
      gExist := True;
      CallerId := gFrameChats[i].UserId;
      tmpFrameChat := gFrameChats[i];
    end;
  end;

  if not gExist then
  begin
    OpenChatFrm(UserName, CallerId);
    i := Length(gFrameChats) - 1;
    gFrameChats[i].ShowMessage(address, message);
  end
  else
  begin
    if Assigned(tmpFrameChat) then
      tmpFrameChat.ShowMessage(address, message);

    if Assigned(tmpFrameCall) then
      tmpFrameCall.ShowMessage(address, message);

    PageControl.ActivePageIndex := tmpFrameChat.PageIndex;
  end;
end;

procedure TFormMainWindow.AbtoPhone_OnClearedCall(ASender: TObject;
  const Msg: WideString; Status, LineId: Integer);
var
  i: Integer;
begin
  gIsCallEstablish := False;
end;

procedure TFormMainWindow.AbtoPhone_OnEstablishedCall(ASender: TObject;
  const Msg: WideString; LineId: Integer);
begin
  gIsCallEstablish := True;
end;

end.
