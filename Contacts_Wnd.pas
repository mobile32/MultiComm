unit Contacts_Wnd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.ComCtrls, System.Actions, Vcl.ActnList, Vcl.ImgList,
  Common_Code;

type
  TFormContactsList = class(TForm)
    pnl2: TPanel;
    pnl3: TPanel;
    ButtonClose: TSpeedButton;
    ListViewContacts: TListView;
    ButtonEdit: TSpeedButton;
    ButtonAdd: TSpeedButton;
    ButtonDelete: TSpeedButton;
    ActionListContacts: TActionList;
    ActionAdd: TAction;
    ActionEdit: TAction;
    ActionDelete: TAction;
    ActionClose: TAction;
    Action1: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionCloseExecute(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  end;

implementation

{$R *.dfm}
uses
  Add_Edit_Wnd, Main_Wnd;

procedure TFormContactsList.ActionAddExecute(Sender: TObject);
var
  AddEditWnd: TAddEditForm;
begin
  AddEditWnd := TAddEditForm.Create(self);
  AddEditWnd.ParentForm := self;
  with AddEditWnd do
  begin
    BtnSave.Action := ActionAdd;
    BtnSave.Caption := 'Zapisz';
    gAdd := True;
  end;
  AddEditWnd.Caption := 'Dodaj u�ytkownika';
  AddEditWnd.Show;
end;

procedure TFormContactsList.ActionCloseExecute(Sender: TObject);
begin
  FormMainWindow.FillForm;
  Close;
end;

procedure TFormContactsList.ActionDeleteExecute(Sender: TObject);
var
  index: integer;
  i: integer;
  cItem: TListItem;
  number: integer;
begin
  if Assigned(ListViewContacts.Selected) then
  begin
    index := ListViewContacts.Selected.Index;
    FormMainWindow.ADOConnectionLoad.Connected := true;
    with FormMainWindow.ADOQuery do
    begin
      Sql.Clear;
      Sql.Add('exec DeleteContact  ' + gContacts[index].UserName);
      number := ExecSql;
      if (number > 0) then
      begin
        ShowMessage('U�ytkownik zosta� usuni�ty!');
      end;
    end;

    for i := index to High(gContacts) - 1 do
    begin
      gContacts[i] := gContacts[i + 1];
    end;

    SetLength(gContacts, Length(gContacts) - 1);

    ListViewContacts.Clear;
    for i := 0 to High(gContacts) do
    begin
      cItem := ListViewContacts.Items.Add();
      cItem.Caption := gContacts[i].CallerId;
      cItem.ImageIndex := gContacts[i].ImageIndex;
    end;
  end;
end;

procedure TFormContactsList.ActionEditExecute(Sender: TObject);
var
  AddEditWnd: TAddEditForm;
  lIndex: integer;
begin
  if Assigned(ListViewContacts.Selected) then
  begin
    AddEditWnd := TAddEditForm.Create(self);
    AddEditWnd.ParentForm := self;
    AddEditWnd.EditImage.Text := 'Wybierz �cie�k� do edycji awatara';
    lIndex := ListViewContacts.Selected.Index;
    with AddEditWnd do
    begin
      BtnSave.Action := ActionEdit;
      BtnSave.Caption := 'Zapisz';
      gAdd := false;
      gCurrentItem := lIndex;
      EditCallerId.Text := gContacts[lIndex].CallerId;
      EditUserName.Text := gContacts[lIndex].UserName;
      EditUserName.readonly := true;
    end;
    AddEditWnd.Caption := 'Edytuj u�ytkownika';
    AddEditWnd.Show;
  end
  else
  begin
    ShowMessage('Zaznacz u�ytkownika');
  end;
end;

procedure TFormContactsList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormMainWindow.GetDatabaseContacts;
end;

procedure TFormContactsList.FormCreate(Sender: TObject);
begin
  Left:=(Screen.Width-Width)  div 2;
  Top:=(Screen.Height-Height) div 2;
end;

end.

