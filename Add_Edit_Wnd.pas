unit Add_Edit_Wnd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList;

type
  TAddEditForm = class(TForm)
    GridPanel1: TGridPanel;
    EditUserName: TEdit;
    Label1: TLabel;
    EditCallerId: TEdit;
    Label2: TLabel;
    EditImage: TEdit;
    ButtonSelectImage: TSpeedButton;
    Panel1: TPanel;
    ButtonSave: TSpeedButton;
    ButtonClose: TSpeedButton;
    Panel2: TPanel;
    ActionListAddEdit: TActionList;
    ActionAdd: TAction;
    ActionEdit: TAction;
    ActionClose: TAction;
    ActionSelectImage: TAction;
    procedure FormCreate(Sender: TObject);
    procedure ActionCloseExecute(Sender: TObject);
    procedure ActionSelectImageExecute(Sender: TObject);
  private
    { Private declarations }
  public
    gAdd: Boolean;
  end;

var
  AddEditForm: TAddEditForm;

implementation

{$R *.dfm}

procedure TAddEditForm.ActionCloseExecute(Sender: TObject);
begin
  Close;
  Free;
end;

procedure TAddEditForm.ActionSelectImageExecute(Sender: TObject);
var
openDialog : TOpenDialog;
begin
  openDialog := TOpenDialog.Create(self);
  openDialog.InitialDir := GetCurrentDir;
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter :=
    'PNG|*.png|BMP|*.bmp|JPG|*.jpg';

  openDialog.FilterIndex := 3;

  if openDialog.Execute then
    EditImage.Text := openDialog.Files[0];

  openDialog.Free;
end;

procedure TAddEditForm.FormCreate(Sender: TObject);
begin
  if gAdd then
  begin
    ButtonSave.Action := ActionListAddEdit.Actions[0];
    ButtonSave.Caption := 'Zapisz';
  end
  else
  begin
    ButtonSave.Action := ActionListAddEdit.Actions[1];
    ButtonSave.Caption := 'Zapisz';
  end;
end;

end.