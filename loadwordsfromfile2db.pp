unit LoadWordsFromFile2DB;

{$MODE Delphi}

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ActnList,
  StdCtrls, ExtCtrls;

type
  TFrmLoadWordsFromFile2DB = class(TForm)
    RgSelectOption: TRadioGroup;
    RbtnLoad1st1000: TRadioButton;
    RbtnLoadAll: TRadioButton;
    RbtnLimitSelection: TRadioButton;
    ActionList1: TActionList;
    PnlMakeSelection: TPanel;
    BtnLoad: TButton;
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
    procedure RbtnLoad1st1000Click(Sender: TObject);
    procedure ActSetLimitsExecute(Sender: TObject);
  private
    LmtClause: string;
    procedure SetLmtClause(Value: string);
    function GetLmtClause: string;
  protected
    property FLmtClause: string read GetLmtClause write SetLmtClause;
  end;

var
  FrmLoadFileDlg: TFrmLoadWordsFromFile2DB;

implementation

{$R *.lfm}

procedure TFrmLoadWordsFromFile2DB.SetLmtClause(Value: string);
begin
  LmtClause := Value;
  lblLimitClause.Text := LmtClause;
end;

function TFrmLoadWordsFromFile2DB.GetLmtClause: string;
begin
  Result := LmtClause;
end;

const
  Lmt2_1000 = ' Limit 0,1000 ';
  LmtLoadAll = ' No limit, load all. ';
  LmtSelect = ' Limit %s, %s )';

procedure TFrmLoadWordsFromFile2DB.RbtnLoad1st1000Click(Sender: TObject);
begin
  FLmtClause := Lmt2_1000;
end;

procedure TFrmLoadWordsFromFile2DB.ActLoadAllRowsExecute(Sender: TObject);
begin
  FLmtClause := LmtLoadAll;
end;

procedure TFrmLoadWordsFromFile2DB.ActMakeSelectionExecute(Sender: TObject);
begin
  PnlMakeSelection.Enabled := RbtnLimitSelection.Checked;
  EdBeginAt.Enabled := RbtnLimitSelection.Checked;
  EdHowMany.Enabled := RbtnLimitSelection.Checked;
  BtnSetLimits.Enabled := RbtnLimitSelection.Checked;
end;

procedure TFrmLoadWordsFromFile2DB.ActSetLimitsExecute(Sender: TObject);
begin
  FLmtClause := Format(LmtSelect, [EdBeginAt.Text, EdHowMany.Text]);
end;

procedure TFrmLoadWordsFromFile2DB.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmLoadWordsFromFile2DB.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
end;

procedure TFrmLoadWordsFromFile2DB.FormCreate(Sender: TObject);
begin
  RbtnLoad1st1000.Checked := True;
  PnlMakeSelection.Enabled := False;
  EdBeginAt.Enabled := False;
  EdHowMany.Enabled := False;
  BtnLoad.Enabled := False;
end;

end.
