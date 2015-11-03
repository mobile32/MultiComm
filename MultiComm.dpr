program MultiComm;

uses
  Vcl.Forms,
  Call_Frm in 'Call_Frm.pas' {FrameCall: TFrame},
  Chat_Frm in 'Chat_Frm.pas' {FrameChat: TFrame},
  SIPVoipSDK_TLB in 'SIPVoipSDK_TLB.pas',
  Login_Wnd in 'Login_Wnd.pas' {FormLog},
  Main_Wnd in 'Main_Wnd.pas' {FormMainWindow},
  Settings_Wnd_OLD in 'Settings_Wnd_OLD.pas' {FormSettings},
  Contacts_Wnd in 'Contacts_Wnd.pas' {FormContactsList},
  Vcl.Themes,
  Vcl.Styles,
  Settings_Wnd in 'Settings_Wnd.pas' {SettingsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMainWindow, FormMainWindow);
  Application.Run;
end.
