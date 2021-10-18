unit GetParams4Read;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms, Dialogs, ActnList,
  StdCtrls, ExtCtrls, WordDmod
  ;

type

	{ TFrmGetDbParams }

  TFrmGetDbParams = class(TForm)
    RgSelectOption: TRadioGroup;
    RbtnLoad1st1000: TRadioButton;
    RbtnLoadAll: TRadioButton;
    RbtnLimitSelection: TRadioButton;
    ActionList1: TActionList;
    PnlMakeSelection: TPanel;
    BtnOk: TButton;
    BtnCancel: TButton;
    LblSetLimits: TLabel;
    Label1: TLabel;
    LblHowMany: TLabel;
    EdBeginAt: TEdit;
    EdHowMany: TEdit;
    ActMakeSelection: TAction;
    ActLoadAllRows: TAction;
    ActLoad1st1000: TAction;
    BtnSetLimits: TButton;
    ActSetLimits: TAction;
    capLimitClause: TLabel;
    lblLimitClause: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActMakeSelectionExecute(Sender: TObject);
    procedure ActLoadAllRowsExecute(Sender: TObject);
    procedure ActSetLimitsExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ActLoad1st1000Execute(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
		procedure RbtnLimitSelectionChange(Sender: TObject);
		procedure RbtnLoad1st1000Click(Sender: TObject);
		procedure RbtnLoadAllClick(Sender: TObject);
  private
    LmtClause: string;
    procedure SetLmtClause(Value: string);
    function GetLmtClause: string;
  published
    property FLmtClause: string read GetLmtClause write SetLmtClause;
  end;

var
  FrmGetDbParams: TFrmGetDbParams;

implementation

{$R *.lfm}

uses Words;

procedure TFrmGetDbParams.SetLmtClause(Value: string);
begin
  LmtClause := Value;
  lblLimitClause.Text := LmtClause;
end;

function TFrmGetDbParams.GetLmtClause: string;
begin
  Result := LmtClause;
end;

procedure TFrmGetDbParams.ActLoad1st1000Execute(Sender: TObject);
begin
  FLmtClause := Lmt2_1000;
end;

procedure TFrmGetDbParams.ActLoadAllRowsExecute(Sender: TObject);
begin
  FLmtClause := LmtLoadAll;
end;

procedure TFrmGetDbParams.ActMakeSelectionExecute(Sender: TObject);
begin
  PnlMakeSelection.Enabled := RbtnLimitSelection.Checked;
  EdBeginAt.Enabled := RbtnLimitSelection.Checked;
  EdBeginAt.Text := '';
  EdBeginAt.SetFocus;
  EdHowMany.Enabled := RbtnLimitSelection.Checked;
  BtnSetLimits.Enabled := RbtnLimitSelection.Checked;
end;

procedure TFrmGetDbParams.ActSetLimitsExecute(Sender: TObject);
begin
  FLmtClause := Format(LmtSelect, [EdBeginAt.Text, EdHowMany.Text]);
end;

procedure TFrmGetDbParams.BtnCancelClick(Sender: TObject);
begin
  FLmtClause := '';
  Close;
end;

procedure TFrmGetDbParams.BtnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmGetDbParams.RbtnLimitSelectionChange(Sender: TObject);
begin
  PnlMakeSelection.Enabled := RbtnLimitSelection.Checked;
  EdBeginAt.Enabled := RbtnLimitSelection.Checked;
  EdBeginAt.Text := '';
  EdBeginAt.SetFocus;
  EdHowMany.Enabled := RbtnLimitSelection.Checked;
  BtnSetLimits.Enabled := RbtnLimitSelection.Checked;
end;

procedure TFrmGetDbParams.RbtnLoad1st1000Click(Sender: TObject);
begin
  FLmtClause := Lmt2_1000;
end;

procedure TFrmGetDbParams.RbtnLoadAllClick(Sender: TObject);
begin
  FLmtClause := LmtLoadAll;
end;

procedure TFrmGetDbParams.FormActivate(Sender: TObject);
begin
  if FLmtClause = '' then
    Exit;
end;

procedure TFrmGetDbParams.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
end;

procedure TFrmGetDbParams.FormCreate(Sender: TObject);
begin
  RbtnLoad1st1000.Checked := True;
  PnlMakeSelection.Enabled := False;
  EdBeginAt.Enabled := False;
  EdHowMany.Enabled := False;
end;

end.
